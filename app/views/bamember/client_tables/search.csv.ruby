require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  csv << ["ID"] + @show_columns.map { |co| co.name } + ["登録日時", "変更日時"]
  @datas.each do |d|
    csv << [d[:id]] + @show_columns.map { |co| d[co.column_name] } + [d[:created_at], d[:updated_at]]
  end
end

NKF::nkf('--sjis -Lw', csv_str)
