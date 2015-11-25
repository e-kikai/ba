class Bamember::ClientTablesController < ApplicationController
  before_action :find_table
  before_action :check_session_spreadseet, only: [:csv_matching, :csv_matching_check, :csv_confirm, :csv_update, :csv_error]

  def search
    @datas = @table.datas

    # 検索条件
    @s = []
    if params[:s].present?
      search_query = {}
      params[:s].each do |s|
        value = s[:value].to_s.normalize_charwidth.strip
        next if value.blank?
        search_query["#{s[:column_name]}_#{s[:cond]}"] = value
        @s << { column_name: s[:column_name], cond: s[:cond], value: value }
      end
    end

    if search_query.present?
      @datas = @datas.search(search_query).result
    end

    # 並び順
    @order_column = params[:order_column].presence || :id
    @order_type   = params[:order_type].presence   || :asc

    @datas = @datas.order("CASE WHEN #{@order_column} IS NULL OR #{@order_column} = '' THEN 1 ELSE 0 END")

    if oc = @table.client_columns.find_by(column_name: @order_column)
      @datas = @datas.order("CAST(#{@order_column} as #{oc.db_column_type[:type]}) #{@order_type}")
    end

    @datas = @datas.order(@order_column => @order_type).order(:id)

    # CSV出力
    respond_to do |format|
      format.html do
        @datas = @datas.page(params[:page])
      end
      format.csv { send_data render_to_string,
        content_type: 'text/csv;charset=shift_jis',
        filename: "csv_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end
  end

  def csv
  end

  def csv_upload
    file = params[:file]

    spreadsheet = case File.extname(file.original_filename)
    when '.csv'  then Roo::CSV.new(file.path, csv_options: {encoding: Encoding::SJIS})
    when '.xls'  then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    when '.ods'  then Roo::OpenOffice.new(file.path)
    else raise "不明なファイルタイプです: #{file.original_filename}"
    end

    session[:csv] = {
      header: spreadsheet.row(1).map { |v| v.to_s.normalize_charwidth.strip },
      body:   (2..spreadsheet.last_row).map do |i|
        next if spreadsheet.row(i).all?(&:blank?)
        spreadsheet.row(i).map { |v| v.to_s.normalize_charwidth.strip }
      end.compact,
      table_header: [],
      method:       [],
      option:       {}
    }

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_matching/"
  end

  def csv_matching
  end

  def csv_matching_check
    session[:csv][:option]       = params[:option]
    session[:csv][:table_header] = params[:table_header].map { |k, v| v }
    session[:csv][:method]       = params[:method].map { |k, v| v }
    @csv = session[:csv]

    matching_id_key = @csv[:header].length
    error_key       = @csv[:header].length + 1

    # 項目設定がされているか
    if @csv[:table_header].select.with_index { |h, i| h.present? && @csv[:method][i] == "matching" }.blank? && @csv[:option][:unmatch] != "new"
      raise "マッチング項目が設定されていません"
    # elsif @csv[:header].none?.with_index { |h, i| @csv[:table_header][i].present? && (@csv[:method][i].blank? || @csv[:method][i] == :update) }
    #   raise "保存・上書き項目が設定されていません"
    end

    @csv[:body].each_with_index do |d, key|
      # AND条件マッチング
      if @csv[:option][:if] == "and" || @csv[:option][:if].blank?
        res = @table.datas

        @csv[:header].each_with_index do |h, i|
          if @csv[:table_header][i].present? && @csv[:method][i] == "matching"
            res = res.where(@csv[:table_header][i] => d[i])
          end
        end
      end

      # OR条件マッチング
      if @csv[:option][:if]  == "or" || (@csv[:option][:if] .blank? && res.blank?)
        cond = nil
        @csv[:header].each_with_index do |h, i|
          if @csv[:table_header][i].present? && @csv[:method][i] == "matching"
            cond = cond ? cond.or(@table.klass.arel_table[@csv[:table_header][i]].eq(d[i])) : @table.klass.arel_table[@csv[:table_header][i]].eq(d[i])
          end
        end
        res = @table.klass.where(cond)
      end

      @csv[:body][key][matching_id_key] = res.pluck(:id).join(", ")
      @csv[:body][key][error_key] = if res.count > 1
        "複数マッチしました"
      elsif @csv[:option][:unmatch] != "new" && res.count == 0
        "マッチしませんでした"
      else
        # 新規かどうか
        data = res.count == 1 ? res.first : @table.klass.new

        @csv[:header].each_with_index do |h, i|
          next if @csv[:table_header][i].blank?

          if @csv[:method][i] == "update" \
             || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
             || (@csv[:method][i] == "matching" && res.count == 0 && @csv[:table_header][i] != "id")
            data[@csv[:table_header][i]] = d[i]
          end
        end

        # バリデーション・フィルタリング(saveはまだしない)
        data.valid?
        data.errors.messages.map do |k, v|
          v.map { |mes| "#{k} #{mes}" }.join("\n")
        end.join("\n")
      end
    end

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_confirm/"
  rescue => e
    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_matching/", alert: e.message
  end

  def csv_confirm
  end

  def csv_update
    matching_id_key = @csv[:header].length
    error_key       = @csv[:header].length + 1

    # トランザクション
    @table.klass.transaction do
      @csv[:body].each_with_index do |d, key|
        next if d[error_key].present?

        matching_id = d[matching_id_key].split(",")

        # データ取り出し、新規作成
        if matching_id.blank? && @csv[:option][:unmatch] == "new"
          data = @table.klass.new
        elsif matching_id.count == 1
          data = @table.datas.find(matching_id.first)
        else
          next
        end

        # データ保存部分
        @csv[:header].each_with_index do |h, i|
          next if @csv[:table_header][i].blank?

          if @csv[:method][i] == "update" \
             || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
             || (@csv[:method][i] == "matching" && matching_id.blank? && @csv[:table_header][i] != "id")
            data[@csv[:table_header][i]] = d[i]
          end
        end

        data.save!
      end
    end
    redirect_to "/bamember/clients/#{@table.client.id}/", notice: "データをテーブルに反映しました"
  rescue => e
    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_confirm/", alert: e.message
  end

  def csv_error
    respond_to do |format|
      format.csv { send_data render_to_string,
        content_type: 'text/csv;charset=shift_jis',
        filename: "error_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end
  end

  def edit
  end

  def update
    if @table.update(client_table_params)
      redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}の項目を変更しました"
    else
      render :edit
    end
  end

  def destroy
    @table.soft_destroy
    redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}の項目を削除しました"
  end

  ### data table ###
  def data_new
    @data = @table.klass.new
  end

  def data_create
    @data = @table.klass.create(data_params)

    if @data.save
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id} #{@data.name}を新規作成しました"
    else
      render :data_new
    end
  end


  def data_show
    @data = @table.datas.find(params[:data_id])
  end

  def data_edit
    @data = @table.datas.find(params[:data_id])
  end

  def data_update
    @data = @table.datas.find(params[:data_id])

    if @data.update(data_params)
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id} #{@data.name}を保存しました"
    else
      render :data_edit
    end
  end

  def data_destroy
    @data = @table.datas.find(params[:data_id])
    @data.soft_destroy

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id} #{@data.name}を削除しました"
  end

  private

  def find_table
    raise "クライアント情報が取得できません" unless @client = Client.find(params[:client_id])
    raise "テーブル情報が取得できません"     unless @table  = ClientTable.find(params[:id])
    raise "このテーブルはクライアント所有ではありません" if @table.client_id != @client.id
  end

  def check_session_spreadseet
    if session[:csv][:body].blank?
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv/", alert: 'ファイルがアップロードされていません'
    end

    @csv = session[:csv]
  end

  def client_table_params
    params.require(:client_table).permit(client_columns_attributes: [:id, :name, :column_type, :selector, :default, :unique, :presence, :hidden, :_destroy])
  end

  # def csv_matching_params
  #   params.require(:columns)
  # end

  def data_params
    params.require(:client_table_data).permit(@table.show_client_columns.map(&:column_name))
  end
end
