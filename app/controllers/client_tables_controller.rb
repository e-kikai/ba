class ClientTablesController < ApplicationController
  before_action :find_table

  def search
    @datas, @s, @order_column, @order_type = @table.klass.table_search params

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

  def data_show
    @data = @table.datas.find(params[:data_id])
  end

  private

  def find_table
    raise "テーブル情報が取得できません"                 unless @table  = ClientTable.find(params[:id])
    raise "このテーブルはクライアント所有ではありません" if @table.client_id != @client.id
  end
end
