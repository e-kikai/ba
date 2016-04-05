class Bamember::ClientTablesController < Bamember::ApplicationController
  before_action :find_client
  before_action :find_table, except: [:new, :create]
  before_action :find_company_table, only: [:test_01, :relation, :relation_confirm, :relation_do]
  before_action :check_session_spreadseet, only: [:csv_matching, :csv_matching_check, :csv_confirm, :csv_update, :csv_error]
  before_action :check_company_id, only: [:relation, :relation_confirm, :relation_do, :test_01]

  def new
    @table = @client.client_tables.new
  end

  def create
    if ClientTable.create(client_id: @client.id, name: params[:client_table][:name], table_name: "c#{@client.id}_#{Time.now.strftime('%Y%m%d%H%M%S')}_#{rand(999)}")
      redirect_to "/bamember/clients/#{@client.id}/", notice: "#{client_table_params[:name]}テーブルを追加しました"
    else
      render :new
    end
  end

  def search
    @datas = @klass.company_relation.table_search(params[:s]).table_order(params[:order]).order(:id)

    # 表示項目
    @show_columns = params[:all].present? ? @table.client_columns : @table.client_columns.show

    @sums = @datas.group("")

    # CSV出力
    respond_to do |format|
      format.html do
        @pdatas = @datas.page(params[:page])
      end

      format.csv { send_data render_to_string,
        content_type: 'text/csv;charset=shift_jis',
        filename: "csv_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }

      format.js {}
    end
  end

  def test_01
    params[:x_sepa] = params[:x_sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s).join(", ").presence || "3, 6, 9, 12, 15, 18, 21, 24"
    params[:y_sepa] = params[:y_sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s).join(", ").presence || "1, 2, 3, 4, 6, 10, 15, 20, 30"

    @x_unit, x_date, x_select, x_column = case params[:x]
    when /^(.*)__(.*)__(.*)$/
      co = @table.client_columns.find_by(column_name: $1)

      case co.column_type
      when "datetime"
        x_select = "CURRENT_DATE - CAST(#{$3 == "min" ? "MIN" : "MAX"}(#{$1}) AS TIMESTAMP)"
        case $2
        when "day"
          ["日", "DAY", x_select, $1]
        when "year"
          ["年", "YEAR", x_select, $1]
        else
          ["ヶ月", "MONTH", x_select, $1]
        end
      when "integer", "float", "yen"
        func = (["sum", "max", "min", "avg"].include? $3) ? $3 : "MAX"
        [($2 == "yen" ? "円" : ""), "", "#{func}(#{$1})", $1]
      end
    else
      params[:x] = :count
      ["回", "", " count(*) ", "company_id"]
    end

    @y_unit, y_date, y_select, y_column = case params[:y]
    when /^(.*)__(.*)__(.*)$/
      co = @table.client_columns.find_by(column_name: $1)

      case co.column_type
      when "datetime"
        y_select = "CURRENT_DATE - CAST(#{$3 == "min" ? "MIN" : "MAX"}(#{$1}) AS TIMESTAMP)"
        case $2
        when "day"
          ["日", "DAY", y_select, $1]
        when "year"
          ["年", "YEAR", y_select, $1]
        else
          ["ヶ月", "MONTH", y_select, $1]
        end
      when "integer", "float", "yen"
        func = (["sum", "max", "min", "avg"].include? $3) ? $3 : "MAX"
        [($2 == "yen" ? "円" : ""), "", "#{func}(#{$1})", $1]
      end
    else
      params[:y] = "count"
      ["回", "", " count(*) ", "company_id"]
    end

    # companies_sql = "SELECT company_id, #{x_select} as ax, #{y_select} as ay FROM #{@table.table_name} WHERE company_id IS NOT NULL AND #{x_column} IS NOT NULL AND #{y_column} IS NOT NULL GROUP BY company_id"

    companies_sql = @klass.select("company_id, #{x_select} as ax, #{y_select} as ay")
      .where.not(company_id: nil, x_column => nil, y_column => nil).group(:company_id).to_sql

    x_case = params[:x_sepa].split(",").inject(" CASE ") do |s, i|
      s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN cs.ax <= ? THEN ? ", "#{i} #{x_date}", "#{i}"])
    end + " ELSE 'more' END "

    y_case = params[:y_sepa].split(",").inject(" CASE ") do |s, i|
      s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN cs.ay <= ? THEN ? ", "#{i} #{y_date}", "#{i}"])
    end + " ELSE 'more' END "

    sql = "SELECT  #{x_case} AS x, #{y_case} AS y, count(*) as count, string_agg(CAST(company_id AS TEXT), ' ') as company_ids
      FROM (#{companies_sql}) cs GROUP BY x, y ORDER BY x, y;"

    @sums = @klass.find_by_sql(sql)
  rescue => e
    @alert = e.message
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

    CSV.foreach(@csv[:body_path]) do |d|
      if matchings.present?
        values = @table.filter(matchings.map { |m| [ m[:table_header], d[m[:i]] ] }.to_h)

        if values.has_value? ""
          count = :skip
        else
          # AND条件マッチング
          if @csv[:option][:if] == "and" || @csv[:option][:if].blank?
            res = @klass.where(values)
          end

          # OR条件マッチング
          if @csv[:option][:if] == "or" || (@csv[:option][:if].blank? && res.exists? && matchings.length > 1)
            cond = nil
            values.each do |k, v|
              cond = cond ? cond.or(@klass.arel_table[k].eq(v)) : @klass.arel_table[k].eq(v)
            end

            res = @klass.where(cond)
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
          counts[:none] += 1
          if @csv[:option][:unmatch] == "new"
            data = @klass.new # 新規登録
          else
            d[error_key] = "マッチしませんでした"
          end
        when :skip
          counts[:skip] += 1
          if @csv[:option][:unmatch] == "new"
            data = @klass.new # 新規登録
          else
            d[error_key] = "マッチング項目が空白なのでスキップ"
          end
        else
          counts[:overlap] += 1
          d[error_key] = "複数マッチ:#{count}件"
        end

      else
        counts[:skip] += 1
        data = @klass.new
      end

      # バリデーション
      if data.present?
        @csv[:header].each_with_index do |h, i|
          next if @csv[:table_header][i].blank?

          # データ(バリデーション用に)格納
          if @csv[:method][i] == "update" \
             || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
             || (@csv[:method][i] == "matching" && (count == 0 || count == :skip) && @csv[:table_header][i] != "id")
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
    @klass.transaction do
      CSV.foreach(@csv[:body_path]) do |d|
        next if d[error_key].present?

        matching_ids = d[matching_id_key].try(:split, ",")

        # データ取り出し、新規作成
        if matching_ids.blank? && @csv[:option][:unmatch] == "new"
          data = @klass.new
        elsif matching_ids.length == 1
          data = @klass.find(matching_ids.first)
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
    @data = @klass.new
  end

  def data_create
    @data = @klass.create(data_params)

    if @data.save
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を新規作成しました"
    else
      render :data_new
    end
  end


  def data_show
    @data = @klass.company_relation.find(params[:data_id])
  end

  def data_edit
    @data = @klass.find(params[:data_id])
  end

  def data_update
    @data = @klass.find(params[:data_id])

    if @data.update(data_params)
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を保存しました"
    else
      render :data_edit
    end
  end

  def data_destroy
    @data = @klass.find(params[:data_id])
    @data.soft_destroy

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を削除しました"
  end

  def relation
    params[:relations] = 3.times.map { |i| { company_column: "", child_column: "" } }
  end

  def relation_confirm
    @res = @klass.relation_matching(params[:relations])
  rescue => e
    flash[:alert] = e.message
    render :relation
  end

  def relation_error
    @res = @klass.relation_matching(params[:relations])

    @overlap = @klass.where(id: (@res.select { |k, v| v.count > 1 }.keys))
    @nodata  = @klass.where(id: (@res.select { |k, v| v.count == 1 && v[0][1].blank? }.keys))

    respond_to do |format|
      format.csv { send_data render_to_string,
        content_type: 'text/csv;charset=shift_jis',
        filename: "error_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end
  rescue => e
    flash[:alert] = e.message
    render :relation
  end

  def relation_do
    @res = @klass.relation_matching(params[:relations])
    @res.select { |k, v| v.count == 1 && v[0][1].present? }.each do |id, c|
      @klass.update(id, {company_id: c[0][1]})
    end

    redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}テーブルのリレーションを更新しました"
  rescue => e
    flash[:alert] = e.message
    render :relation_confirm
  end

  private

  def find_client
    raise "クライアント情報が取得できません" unless @client = Client.find(params[:client_id])
  end

  def find_table
    raise "テーブル情報が取得できません"                 unless @table = ClientTable.find(params[:id])
    raise "このテーブルはクライアント所有ではありません" if     @table.client_id != @client.id
    raise "テーブルデータ情報が取得できません"           unless @klass = @table.klass
  end

  def find_company_table
    raise "このテーブルは会社テーブルです" if @table.company?
    @company_table = @client.company_table
  end

  def check_session_spreadseet
    if session[:csv][:header].blank?
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv/", alert: 'ファイルがアップロードされていません'
    end

    @csv = session[:csv]
  end

  def client_table_params
    params.require(:client_table).permit(:name, client_columns_attributes: [:id, :name, :column_type, :selector, :default, :unique, :presence, :hidden, :sumally, :order_no, :_destroy])
  end

  def data_params
    params.require(@klass.name.underscore).permit(@table.show_client_columns.map(&:column_name))
  end

  def check_company_id
    unless @table.company_id_column
      redirect_to "/bamember/clients/#{@table.client.id}/", alert: "会社IDがありません"
    end
  end
end
