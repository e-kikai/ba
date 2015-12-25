class Bamember::ClientTablesController < Bamember::ApplicationController
  before_action :find_table
  before_action :check_session_spreadseet, only: [:csv_matching, :csv_matching_check, :csv_confirm, :csv_update, :csv_error]

  def search
    @datas, @s, @order_column, @order_type = @table.klass.table_search(params)

    # 表示項目
    @show_columns = params[:all].present? ? @table. client_columns : @table.client_columns.show

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

    # データが大量のため、セッションではなくテンポラリファイルに一時保存
    csv_count = 0
    tf = Tempfile.create(['csv-'])
    (2..spreadsheet.last_row).each do |i|
      next if spreadsheet.row(i).all?(&:blank?)
      tf.puts(CSV.generate_line(spreadsheet.row(i).map { |v| v.to_s.normalize_charwidth.strip }))
      csv_count += 1
    end
    tf.close

    session[:csv] = {
      header: spreadsheet.row(1).map { |v| v.to_s.normalize_charwidth.strip },
      first:  spreadsheet.row(2).map { |v| v.to_s.normalize_charwidth.strip },

      body_path:    tf.path,

      table_header: [],
      method:       [],
      option:       {},

      counts:       { all: csv_count },
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

    counts = {
      all:      session[:csv][:counts][:all],
      match:    0,
      overlap:  0,
      none:     0,
      new:      0,
      skip:     0,
      notvalid: 0,
    }

    # 項目設定がされているか
    matchings = []
    @csv[:table_header].each.with_index do |h, i|
      matchings << {table_header: h, i: i } if h.present? && @csv[:method][i] == "matching"
    end

    raise "マッチング項目が設定されていません" if matchings.blank? && @csv[:option][:unmatch] != "new"

    tf = Tempfile.create(['csv-']) # 一時保存ファイル

    klass = @table.klass
    CSV.foreach(@csv[:body_path]) do |d|
      if matchings.present?
        values = @table.filter(matchings.map { |m| [ m[:table_header], d[m[:i]] ] }.to_h)

        if values.has_value? ""
          count = :skip
        else
          # AND条件マッチング
          if @csv[:option][:if] == "and" || @csv[:option][:if].blank?
            res = klass.where(values)
          end

          # OR条件マッチング
          if @csv[:option][:if] == "or" || (@csv[:option][:if].blank? && res.exists? && matchings.length > 1)
            cond = nil
            values.each do |k, v|
              cond = cond ? cond.or(klass.arel_table[k].eq(v)) : klass.arel_table[k].eq(v)
            end

            res = klass.where(cond)
          end

          count              = res.count
          matchng_ids        = res.limit(10).pluck(:id)
          d[matching_id_key] = matchng_ids.join(", ")
        end

        case count
        when 1
          counts[:match] += 1
          data = res.first # マッチ
        when 0
          if @csv[:option][:unmatch] == "new"
            counts[:new] += 1
            data = klass.new # 新規登録
          else
            counts[:none] += 1
            d[error_key] = "マッチしませんでした"
          end
        when :skip
          counts[:skip] += 1
          d[error_key] = "マッチング項目が空白なのでスキップ"
        else
          counts[:overlap] += 1
          d[error_key] = "複数マッチ:#{count}件"
        end

      else
        counts[:new] += 1
        data = klass.new
      end

      # バリデーション
      if data.present?
        @csv[:header].each_with_index do |h, i|
          next if @csv[:table_header][i].blank?

          # データ(バリデーション用に)格納
          if @csv[:method][i] == "update" \
             || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
             || (@csv[:method][i] == "matching" && res.count == 0 && @csv[:table_header][i] != "id")
            data[@csv[:table_header][i]] = d[i]
          end
        end

        # バリデーション(saveはまだしない)
        data.valid?
        d[error_key] = data.errors.messages.map do |k, v|
          v.map { |mes| "#{k} #{mes}" }.join("\n")
        end.join("\n")

        counts[:notvalid] += 1 if d[error_key].present?
      end

      tf.puts CSV.generate_line(d)
    end

    session[:csv][:counts]    = counts
    session[:csv][:body_path] = tf.path

    tf.close

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
    klass = @table.klass
    klass.transaction do
      CSV.foreach(@csv[:body_path]) do |d|
        next if d[error_key].present?

        matching_ids = d[matching_id_key].try(:split, ",")

        # データ取り出し、新規作成
        if matching_ids.blank? && @csv[:option][:unmatch] == "new"
          data = klass.new
        elsif matching_ids.length == 1
          data = klass.find(matching_ids.first)
        else
          next
        end

        # データ保存部分
        @csv[:header].each_with_index do |h, i|
          next if @csv[:table_header][i].blank?

          if @csv[:method][i] == "update" \
             || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
             || (@csv[:method][i] == "matching" && matching_ids.blank? && @csv[:table_header][i] != "id")
            data[@csv[:table_header][i]] = d[i]
          end
        end

        data.save!
      end
    end

    # 保存済のCSV情報をクリア
    session[:csv] = nil
    ActiveRecord::Base.connection.execute("VACUUM;")
    ActiveRecord::Base.connection.execute("REINDEX;")

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
      redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}テーブルの項目を変更しました"
    else
      render :edit
    end
  end

  def destroy
    @table.soft_destroy
    redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}テーブルを削除しました"
  end

  ### data table ###
  def data_new
    @data = @table.klass.new
  end

  def data_create
    @data = @table.klass.create(data_params)

    if @data.save
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を新規作成しました"
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
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を保存しました"
    else
      render :data_edit
    end
  end

  def data_destroy
    @data = @table.datas.find(params[:data_id])
    @data.soft_destroy

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を削除しました"
  end

  private

  def find_table
    raise "クライアント情報が取得できません" unless @client = Client.find(params[:client_id])
    raise "テーブル情報が取得できません"     unless @table  = ClientTable.find(params[:id])
    raise "このテーブルはクライアント所有ではありません" if @table.client_id != @client.id
  end

  def check_session_spreadseet
    if session[:csv][:header].blank?
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv/", alert: 'ファイルがアップロードされていません'
    end

    @csv = session[:csv]
  end

  def client_table_params
    params.require(:client_table).permit(:name, client_columns_attributes: [:id, :name, :column_type, :selector, :default, :unique, :presence, :hidden, :order_no, :_destroy])
  end

  def data_params
    params.require(:client_table_data).permit(@table.show_client_columns.map(&:column_name))
  end
end
