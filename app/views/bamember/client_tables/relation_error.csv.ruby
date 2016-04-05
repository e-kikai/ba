require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  csv << ["ID"] + @table.client_columns.map { |co| co.name } + ["登録日時", "変更日時", "エラー"]
  @overlap.each do |d|
    csv << [d[:id]] + @table.client_columns.map { |co| d[co.column_name] } + [d[:created_at], d[:updated_at], "重複しています"]
  end

  @nodata.each do |d|
    csv << [d[:id]] + @table.client_columns.map { |co| d[co.column_name] } + [d[:created_at], d[:updated_at], "マッチングしませんでした"]
  end
end

NKF::nkf('--sjis -Lw', csv_str)
