require 'nkf'

csv = NKF::nkf('--sjis -Lw', (["ID"] + @show_columns.map { |co| co.name } + ["登録日時", "変更日時"]).to_csv)
# @datas.find_each do |d|
#   line = [d[:id]] + @show_columns.map { |co| d[co.column_name] } + [d[:created_at], d[:updated_at]]
#   csv << NKF::nkf('--sjis -Lw', line.to_csv)
# end

ActiveRecord::Base.connection.execute(@datas.to_sql).each do |row|
    line = [row["id"]] + @show_columns.map { |co| row[co.column_name] } + [row["created_at"], row["updated_at"]]
    csv << NKF::nkf('--sjis -Lw', line.to_csv)
end

csv
