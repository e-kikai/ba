class Bamember::ClientTablesController < Bamember::ApplicationController
  before_action :find_client
  before_action :find_table, except: [:new, :create]
  before_action :find_company_table, only: [:rfm, :relation, :relation_confirm, :relation_do]

  skip_before_filter :authenticate_bamember!, only: :bi

  rescue_from RuntimeError, with: :runtime_error

  def show
    searchurls = @table.searchurls.where(summary: true)
    @summaries  = searchurls.map do |su|
      if su.target = "sum"
        shaping_params = @klass.shaping_params(su.query["s"])
        datas          = @klass.table_search_02(shaping_params)
        sum_params     = @klass.sum_shaping_params(params[:sum])
        sums           = datas.table_sum(sum_params)
        all_count      = @klass.all.count

        {searchurl: su, sums: sums, all_count: all_count, s_params: shaping_params, sum_params: sum_params}
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

  def search
    @s_params     = @klass.shaping_params(params[:s])
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
    @s_params = @klass.shaping_params(params[:s])
    @datas    = @klass.table_search_02(@s_params)
  end

  def data_bulk_update
    count = @klass.bulk_destroy(params[:bulk_method], params[:s])

    redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/", notice: "#{@table.name}テーブルのデータ#{count}件を一括削除しました"
  rescue => e
    @s_params = @klass.shaping_params(params[:s])
    @datas    = @klass.table_search_02(@s_params)

    flash[:alert] = "データの一括処理に失敗しました : #{e.message}"
    render :data_bulk
  end

  # PoweBI用CSV出力
  def bi
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
    @s_params  = @klass.shaping_params(params[:s])
    @datas     = @klass.table_search_02(@s_params)

    @sum_params = @klass.sum_shaping_params(params[:sum])
    @sums       = @datas.table_sum(@sum_params)
    @all_count  = @klass.all.try(@sum_params[:method], @sum_params[:column])
  end

  def sum_update_company
    @s_params  = @klass.shaping_params(params[:s])
    @datas     = @klass.table_search_02(@s_params)

    @sum_params = @klass.sum_shaping_params(params[:sum])
    @sums       = @datas.table_sum(@sum_params)
    @all_count  = @klass.all.try(@sum_params[:method], @sum_params[:column])

    error_mes = if params[:column].blank?
      "保存先の項目が選択されていません"
    elsif @sum_params.dig("axis", 0, "column") != "company_id"
      "X軸項目が会社IDではありません"
    elsif @sum_params.dig("axis", 1, "column").present?
      "Y軸項目は空白にしてください"
    else
      nil
    end

    if error_mes.blank?
      company_klass = @client.company_table.klass
      @sums.each do |k, v|
        next if v.nil?
        begin
          data = company_klass.find(k)

          # 空白に保存
          next if params[:method] == "save" && data[params[:column]].present?

          data.update(params[:column] => v)
        rescue
          next
        end
      end

      redirect_to "/bamember/clients/#{@table.client.id}/table/#{@table.id}/", notice: "一括変更を反映しました"
    else
      flash[:alert] = error_mes
      render :sum
    end
  end

  def rfm
    @rfm_params = @klass.rfm_shaping_params(params[:rfm])
    @rfms       = @klass.rfm(@rfm_params)
  end

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
