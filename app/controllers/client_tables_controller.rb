class ClientTablesController < ApplicationController
  before_action :find_table
  before_action :find_company_table, only: [:rfm]

  def show
    searchurls = @table.searchurls.where(summary: true)
    @summaries  = searchurls.map do |su|
      if su.target = "sum"
        shaping_params = @klass.shaping_params(su.query["s"])
        datas          = @klass.table_search_02(shaping_params)
        sum_params     = @klass.sum_shaping_params(su.query["sum"])
        sums           = datas.table_sum(sum_params)
        all_count  = @klass.all.table_sum(sum_params.merge("axis" => nil))

        {searchurl: su, sums: sums, all_count: all_count, s_params: shaping_params, sum_params: sum_params}
      end
    end

    if @summaries.present?
      @company_names = @client.company_table.klass.order(:id).pluck(:id, :name).to_h
    end
  end

  def search
    @s_params     = @klass.shaping_params(params[:s])
    @datas        = @klass.table_search_02(@s_params).order(:id)
    @show_columns = params[:all] ? @table.client_columns : @table.client_columns.show
    @sums           = @datas.group("")

    # CSV出力
    respond_to do |format|
      format.html { @pdatas = @datas.page(params[:page]) }
      format.js   { @pdatas = @datas.page(params[:page]) }
      format.csv  { send_data render_to_string,
        content_type: 'text/csv;charset=shift_jis',
        filename: "csv_#{@table.client.name}_#{@table.name}_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      }
    end
  end

  def sum
    @s_params  = @klass.shaping_params(params[:s])
    @datas     = @klass.table_search_02(@s_params)

    @sum_params = @klass.sum_shaping_params(params[:sum])
    @sums       = @datas.table_sum(@sum_params)
    @all_count  = @klass.all.table_sum(@sum_params.merge("axis" => nil))

    @company_names = @client.company_table.klass.order(:id).pluck(:id, :name).to_h

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
  rescue => e
    @alert = e.message
  end

  def searchurls
  end

  def data_show
    @data = @klass.find(params[:data_id])
  end

  private

  def find_table
    raise "テーブル情報が取得できません"                 unless @table = ClientTable.find(params[:id])
    raise "このテーブルはクライアント所有ではありません" if     @table.client_id != @client.id
    raise "テーブルデータ情報が取得できません"           unless @klass = @table.klass
  rescue => e
    redirect_to "/", alert: e.message
  end

  def find_company_table
    raise "このテーブルは会社テーブルです" if @table.company?
    raise "会社IDカラムがありません"       unless @table.company_id_column

    @company_table = @client.company_table
  rescue => e
    redirect_to "/", alert: e.message
  end
end
