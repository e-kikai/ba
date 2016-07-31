class Bamember::ClientTablesController < Bamember::ApplicationController
  before_action :find_client
  before_action :find_table, except: [:new, :create]
  before_action :find_company_table, only: [:rfm, :relation, :relation_confirm, :relation_do]
  # before_action :check_session_spreadseet, only: [:csv_matching, :csv_matching_check, :csv_confirm, :csv_update, :csv_error]

  skip_before_filter :authenticate_bamember!, only: :bi

  rescue_from RuntimeError, with: :runtime_error

  def show
    searchurls = @table.searchurls.where(summary: true)
    @summaries  = searchurls.map do |su|
      if su.target = "sum"
        shaping_params = @klass.shaping_params(su.query["s"])
        datas          = @klass.table_search_02(shaping_params)
        sums           = datas.table_sum(su.query["sum"]).count
        all_count      = @klass.all.count

        {searchurl: su, sums: sums, all_count: all_count}
      end
    end
  end

  def new
    @table = @client.client_tables.new
  end

  def create
    if ClientTable.create_chiid_table(@client.id, params[:client_table][:name])
      redirect_to "/bamember/clients/#{@client.id}/", notice: "#{client_table_params[:name]}テーブルを追加しました"
    else
      render :new
    end
  end

  def destroy
    @table.soft_destroy!
    redirect_to "/bamember/clients/#{@client.id}/", notice: "#{@table.name}テーブルを削除しました"
  end
  require 'nkf'

  def search
    # @datas        = @klass.table_search(params[:s]).company_relation.table_order(params[:order]).order(:id)
    @s_params     = @klass.shaping_params(params[:s])
    # @datas        = @klass.table_search_02(@s_params).company_relation.order(:id)
    @datas        = @klass.table_search_02(@s_params).order(:id)
    @show_columns = params[:all] ? @table.client_columns : @table.client_columns.show

    respond_to do |format|
      format.html { @pdatas = @datas.page(params[:page]) }
      format.js   { render "client_tables/search" }
      format.csv  {
        send_data(render_to_string("client_tables/search.csv.ruby"),
          content_type: 'text/csv;charset=shift_jis',
          filename:     "csv_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
        )
      }
    end
  end

  def data_bulk
    # @datas = @klass.table_search(params[:s])
    @s_params = @klass.shaping_params(params[:s])
    @datas    = @klass.table_search_02(@s_params)
  end

  def data_bulk_update
    count = @klass.bulk_destroy(params[:bulk_method], params[:s])

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/", notice: "#{@table.name}テーブルのデータ#{count}件を一括削除しました"
  rescue => e
    # @datas = @klass.table_search(params[:s])
    @s_params = @klass.shaping_params(params[:s])
    @datas    = @klass.table_search_02(@s_params)

    flash[:alert] = "データの一括処理に失敗しました : #{e.message}"
    render :data_bulk
  end

  # PoweBI用CSV出力
  def bi
    # @datas        = @klass.company_relation.order(:id)
    @datas        = @klass.order(:id)
    @show_columns = @table.client_columns

    respond_to do |format|
      format.csv  {
        send_data(render_to_string("client_tables/search.csv.ruby"),
          content_type: 'text/csv;charset=shift_jis',
          filename:     "bi_csv_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
        )
      }
    end
  end

  def sum
    # @datas = @klass.table_search(params[:s])
    @s_params  = @klass.shaping_params(params[:s])
    @datas     = @klass.table_search_02(@s_params)
    @sums      = @datas.table_sum(params[:sum]).count
    @all_count = @klass.all.count
  end

  def rfm
    @rfm_params = @klass.rfm_shaping_params(params[:rfm])
    @rfms       = @klass.rfm(@rfm_params)

    # params[:x_sepa] = params[:x_sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s).join(", ").presence || "3, 6, 9, 12, 15, 18, 21, 24"
    # params[:y_sepa] = params[:y_sepa].to_s.split(",").map(&:to_i).uniq.sort.map(&:to_s).join(", ").presence || "1, 2, 3, 4, 6, 10, 15, 20, 30"
    #
    # @x_unit, x_date, x_select, x_column = case params[:x]
    # when /^(.*)__(.*)__(.*)$/
    #   co = @table.client_columns.find_by(column_name: $1)
    #
    #   case co.column_type
    #   when "datetime"
    #     x_select = "CURRENT_DATE - CAST(#{$3 == "min" ? "MIN" : "MAX"}(#{$1}) AS TIMESTAMP)"
    #     case $2
    #     when "day"
    #       ["日", "DAY", x_select, $1]
    #     when "year"
    #       ["年", "YEAR", x_select, $1]
    #     else
    #       ["ヶ月", "MONTH", x_select, $1]
    #     end
    #   when "integer", "float", "yen"
    #     func = (["sum", "max", "min", "avg"].include? $3) ? $3 : "MAX"
    #     [($2 == "yen" ? "円" : ""), "", "#{func}(#{$1})", $1]
    #   end
    # else
    #   params[:x] = :count
    #   ["回", "", " count(*) ", "company_id"]
    # end
    #
    # @y_unit, y_date, y_select, y_column = case params[:y]
    # when /^(.*)__(.*)__(.*)$/
    #   co = @table.client_columns.find_by(column_name: $1)
    #
    #   case co.column_type
    #   when "datetime"
    #     y_select = "CURRENT_DATE - CAST(#{$3 == "min" ? "MIN" : "MAX"}(#{$1}) AS TIMESTAMP)"
    #     case $2
    #     when "day"
    #       ["日", "DAY", y_select, $1]
    #     when "year"
    #       ["年", "YEAR", y_select, $1]
    #     else
    #       ["ヶ月", "MONTH", y_select, $1]
    #     end
    #   when "integer", "float", "yen"
    #     func = (["sum", "max", "min", "avg"].include? $3) ? $3 : "MAX"
    #     [($2 == "yen" ? "円" : ""), "", "#{func}(#{$1})", $1]
    #   end
    # else
    #   params[:y] = "count"
    #   ["回", "", " count(*) ", "company_id"]
    # end
    #
    # companies_sql = @klass.select("company_id, #{x_select} as ax, #{y_select} as ay")
    #   .where.not(company_id: nil, x_column => nil, y_column => nil).group(:company_id).to_sql
    #
    # x_case = params[:x_sepa].split(",").inject(" CASE ") do |s, i|
    #   s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN cs.ax <= ? THEN ? ", "#{i} #{x_date}", "#{i}"])
    # end + " ELSE 'more' END "
    #
    # y_case = params[:y_sepa].split(",").inject(" CASE ") do |s, i|
    #   s + ActiveRecord::Base.send(:sanitize_sql_array, [" WHEN cs.ay <= ? THEN ? ", "#{i} #{y_date}", "#{i}"])
    # end + " ELSE 'more' END "
    #
    # sql = "SELECT  #{x_case} AS x, #{y_case} AS y, count(*) as count, string_agg(CAST(company_id AS TEXT), ' ') as company_ids
    #   FROM (#{companies_sql}) cs GROUP BY x, y ORDER BY x, y;"
    #
    # @sums = @klass.find_by_sql(sql)
  end

  # def csv
  # end
  #
  # def csv_upload
  #   ss = @table.spreadsheet(params[:file].path, params[:file].original_filename)
  #
  #   session[:csv] = {
  #     header: ss.row(1).map { |v| v.to_s.normalize_charwidth.strip },
  #     first:  ss.row(2).map { |v| v.to_s.normalize_charwidth.strip },
  #
  #     path:               params[:file].path,
  #     original_filename:  params[:file].original_filename,
  #     count:              ss.last_row - 1,
  #
  #     table_header: [],
  #     method:       [],
  #     option:       {},
  #     result:       {}
  #   }
  #
  #   redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_matching/"
  # end
  #
  # def csv_matching
  # end
  #
  # def csv_matching_check
  #   session[:csv][:option]       = params[:option]
  #   session[:csv][:table_header] = params[:table_header].map { |k, v| v }
  #   session[:csv][:method]       = params[:method].map { |k, v| v }
  #   session[:csv][:result]       = {}
  #   @csv = session[:csv]
  #
  #   # 項目設定がされているか
  #   matchings = []
  #   @csv[:table_header].each.with_index do |h, i|
  #     matchings << {table_header: h, i: i } if h.present? && @csv[:method][i] == "matching"
  #   end
  #
  #   raise "マッチング項目が設定されていません" if matchings.blank? && @csv[:option][:unmatch] != "new"
  #
  #   ctd = @klass.arel_table
  #   ss  = @table.spreadsheet(@csv[:path], @csv[:original_filename])
  #   (2..ss.last_row).each do |r|
  #     d = ss.row(r)
  #
  #     ### すべて空白の列は無視 ###
  #     next if d.all?(&:blank?)
  #
  #     ### マッチング処理 ###
  #     if matchings.present?
  #       # マッチングするためのフィルタリング
  #       values = @table.filter(matchings.map { |m| [ m[:table_header], d[m[:i]] ] }.to_h)
  #
  #       if values.has_value? ""
  #         count = :skip
  #       else
  #         # AND条件マッチング
  #         if @csv[:option][:if] == "and" || @csv[:option][:if].blank?
  #           res = @klass.where(values)
  #         end
  #
  #         # OR条件マッチング
  #         if @csv[:option][:if] == "or" || (@csv[:option][:if].blank? && res.exists? && matchings.length > 1)
  #           cond = nil
  #           values.each do |k, v|
  #             cond = cond ? cond.or(ctd[k].eq(v)) : ctd[k].eq(v)
  #           end
  #           res = @klass.where(cond)
  #         end
  #
  #         match_ids = res.limit(10).pluck(:id)
  #         count     = match_ids.count
  #       end
  #
  #       ### マッチング結果 ###
  #       title, data = case count
  #       when 1 # マッチ
  #         [:match, res.first]
  #       when 0 # マッチしない
  #         if @csv[:option][:unmatch] == "new"
  #           [:new, @klass.new] # 新規登録
  #         else
  #           [:none, nil]
  #         end
  #       when :skip # スキップ
  #         if @csv[:option][:unmatch] == "new"
  #           [:new, @klass.new] # 新規登録
  #         else
  #           [:skip, nil]
  #         end
  #       else
  #         [:overlap, nil]
  #       end
  #     else
  #       title, data = [:new, @klass.new] # 新規登録
  #     end
  #
  #     ### バリデーション ###
  #     if data.present?
  #       @csv[:header].each_with_index do |h, i|
  #         next if @csv[:table_header][i].blank?
  #
  #         # データ(バリデーション用に)格納
  #         if @csv[:method][i] == "update" \
  #            || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
  #            || (@csv[:method][i] == "matching" && title == :new && @csv[:table_header][i] != "id")
  #           data[@csv[:table_header][i]] = d[i]
  #         end
  #       end
  #
  #       # バリデーション(saveはまだしない)
  #       data.valid?
  #       if data.errors.messages.present?
  #         title = :notvalid
  #         error = data.errors.messages.map do |k, v|
  #           v.map { |mes| "#{k} #{mes}" }.join("\n")
  #         end.join("\n")
  #       end
  #     end
  #
  #     session[:csv][:result][r] = [title, match_ids, error]
  #   end
  #
  #   redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_confirm/"
  # rescue => e
  #   redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_matching/", alert: e.message
  # end
  #
  # def csv_confirm
  # end
  #
  # def csv_update
  #   ss  = @table.spreadsheet(@csv[:path], @csv[:original_filename])
  #
  #   @klass.transaction do
  #     @csv[:result].each do |k, v|
  #       # 保存先取得
  #       data = case v[0]
  #       when :new;   @klass.new
  #       when :match; @klass.find(v[1].first)
  #       else nil
  #       end
  #
  #       # CSVデータ取得
  #       d = ss.row(k)
  #
  #       next unless data && d
  #
  #       # データ保存部分
  #       @csv[:header].each_with_index do |h, i|
  #         next if @csv[:table_header][i].blank?
  #
  #         if @csv[:method][i] == "update" \
  #            || (@csv[:method][i] == "save" && data[@csv[:table_header][i]].blank?) \
  #            || (@csv[:method][i] == "matching" && v[0] == :new && @csv[:table_header][i] != "id")
  #           data[@csv[:table_header][i]] = d[i]
  #         end
  #       end
  #
  #       data.save!
  #     end
  #   end
  #
  #   # 保存済のCSV情報をクリア
  #   session[:csv] = nil
  #   ActiveRecord::Base.connection.execute("VACUUM;")
  #   # ActiveRecord::Base.connection.execute("REINDEX;")
  #
  #   redirect_to "/bamember/clients/#{@table.client.id}/", notice: "データをテーブルに反映しました"
  # rescue => e
  #   redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/csv_confirm/", alert: e.message
  # end
  #
  # def csv_error
  #   respond_to do |format|
  #     format.csv { send_data render_to_string,
  #       content_type: 'text/csv;charset=shift_jis',
  #       filename: "error_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
  #     }
  #   end
  # end

  def import_file
    @csvfiles = @table.csvfiles.without_soft_destroyed.order(created_at: :desc).page(params[:page])
  end

  def import_upload
    csvfile = Csvfile.upload(params[:id], params[:file])

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/import_matching/#{csvfile.id}/"
    # notice = "ファイル「#{params[:file][:original_filename]}」をアップロードしました"
    # redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/import_matching/#{csvfile.id}/", notice: notice
  end

  def import_matching
    @csvfile = Csvfile.find(params[:csvfile_id])
  rescue => e
    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/import_file/", alert: e.message
  end

  def import_do
    @csvfile = Csvfile.find(params[:csvfile_id])

    matchings = Import.import_check(params)
    raise "マッチング項目が設定されていません" if matchings.blank? && params[:option][:unmatch] != "new"

    import = Import.create!(
      csvfile_id:      params[:csvfile_id],
      matching_params: params,
      queued_at:       Time.now
    )

    if params[:background].present?
      ImportJob.perform_later(import.id)
      notice =  "バックグラウンドジョブに登録しました"
    else
      ImportJob.perform_now(import.id)
      notice =  "インポートが完了しました"
    end

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/", notice: notice
  rescue => e
    flash[:alert] = e.message
    render :import_matching
  end

  def import_log
    @imports = @table.imports.includes(:csvfile).order(created_at: :desc).page(params[:page])
  end

  def import_delete
    @csvfile = Csvfile.find(params[:csvfile_id])

    File.unlink(@csvfile.path) if File.exist?(@csvfile.path)

    @csvfile.soft_destroy!

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/import_file/", notice: "CSVファイル「#{@csvfile.original_filename}」を削除しました"
  end

  def import_error
    @import = Import.find(params[:import_id])

    respond_to do |format|
      format.csv { send_data render_to_string,
        content_type: 'text/csv;charset=shift_jis',
        filename: "error_#{@table.client.name}_#{@table.name}_#{params[:import_id]}.csv"
      }
    end
  end

  def import_search
    @csvfile = Csvfile.find(params[:csvfile_id])
  rescue => e
    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/import_file/", alert: e.message
  end

  def import_download
    @csvfile = Csvfile.find(params[:csvfile_id])

    send_file(@csvfile.path, filename: @csvfile.original_filename, length: File::stat(@csvfile.path).size)
  rescue => e
    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/import_file/", alert: e.message
  end

  def edit
  end

  def update
    if @table.update(client_table_params)
      @client.reflesh_class # client_table_dataクラス更新
      redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}テーブルの項目を変更しました"
    else
      render :edit
    end
  end

  def destroy
    @table.soft_destroy
    redirect_to "/bamember/clients/#{@table.client.id}/", notice: "#{@table.name}テーブルを削除しました"
  end

  def searchurl_create
    if @table.searchurls.create(
      target: params[:target],
      query:  params.select { |k, v| ["s", "sum", "rfm"].include? k }
    )
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/searchurls/", notice: "検索条件を保存しました"
    else
      render :show
    end
  end

  def searchurls
  end

  def searchurls_update
    if @table.update(searchurls_params)
      redirect_to "/bamember/clients/#{@client.id}/table/#{@table.id}/", notice: "概要を変更しました"
    else
      render :searchurls
    end
  end

  def bi_coop
  end

  def bi_coop_update
    if @table.update(bi_params)
      redirect_to "/bamember/clients/#{@client.id}/table/#{@table.id}/", notice: "ダッシュボードを変更しました"
    else
      render :bi_coop
    end
  end

  ### data table ###
  def data_new
    @data = @klass.new
  end

  def data_create
    @data = @klass.new(data_params)

    if @data.save
      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/search/", notice: "#{@data.id}: #{@data.name}を新規作成しました"
    else
      render :data_new
    end
  end

  def data_show
    # @data = @klass.company_relation.find(params[:data_id])
    @data = @klass.find(params[:data_id])
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
        filename:     "error_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
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

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/", notice: "#{@table.name}テーブルのリレーションを更新しました"
  rescue => e
    flash[:alert] = e.message
    render :relation_confirm
  end

  private

  def find_client
    raise "クライアント情報が取得できませんでした" unless @client = Client.find(params[:client_id])
  rescue => e
    redirect_to "/bamember/", alert: e.message
  end

  def find_table
    raise "テーブル情報が取得できません"                 unless @table = ClientTable.find(params[:id])
    raise "このテーブルはクライアント所有ではありません" if     @table.client_id != @client.id
    raise "テーブルデータ情報が取得できません"           unless @klass = @table.klass
  end

  def find_company_table
    raise "このテーブルは会社テーブルです" if @table.company?
    raise "会社IDカラムがありません"       unless @table.company_id_column

    @company_table = @client.company_table
  end

  def client_table_params
    params.require(:client_table).permit(:name, client_columns_attributes: [:id, :name, :column_type, :selector, :default, :unique, :presence, :hidden, :sumally, :order_no, :_destroy])
  end

  def data_params
    params.require(@klass.name.underscore).permit(@table.show_columns.map(&:column_name))
  end

  def runtime_error(e = nil)
    logger.error e
    logger.error e.backtrace.join("\n")
    redirect_to "/bamember/clients/#{@client.id}/", alert: e.message
  end

  def bi_params
    params.require(:client_table).permit(dashboards_attributes: [:id, :name, :url, :size, :order_no, :soft_destroyed_at])
  end

  def searchurls_params
    params.require(:client_table).permit(searchurls_attributes: [:id, :name, :summary, :query, :size, :order_no, :soft_destroyed_at])
  end
end
