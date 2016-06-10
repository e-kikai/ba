csv = (["ID"] + @show_columns.map { |co| co.name } + ["登録日時", "変更日時"]).to_csv
@datas.find_each do |d|
  csv << ([d[:id]] + @show_columns.map { |co| d[co.column_name] } + [d[:created_at], d[:updated_at]]).to_csv
end

csv
