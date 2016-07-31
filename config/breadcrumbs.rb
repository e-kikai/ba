# Root crumb
# crumb :root do
#   link "HOME", "/"
# end

### client ###
crumb :client_root do
  link "TOP", "/"
end

crumb :table do |table|
  link   "#{table.name}テーブル", "/client_tables/#{table.id}/"
  parent :client_root, table.client
end

crumb :search do |table|
  link   "検索", "/client_tables/#{table.id}/search"
  parent :table, table
end

crumb :sum do |table|
  link   "集計", "/client_tables/#{table.id}/sum"
  parent :table, table
end

crumb :data do |table, data|
  link   data[:name], "/client_tables/#{table.id}/#{data.id}"
  parent :search, table
end

crumb :something do |title|
  link   title
  parent :client_root
end

crumb :table_something do |title, table|
  link   title
  parent :table, table
end

### 管理者画面 ###
crumb :bamember_root do
  link "BAメニュー", "/bamember/"
end

crumb :bamember_something do |title|
  link   title
  parent :bamember_root
end

crumb :clients_show do |client|
  link   "#{client.name} メニュー", "/bamember/clients/#{client.id}"
  parent :bamember_root
end

crumb :clients_table do |table|
  link   "#{table.name}テーブル", "/bamember/clients/#{table.client.id}/table/#{table.id}/"
  parent :clients_show, table.client
end

crumb :clients_something do |title, client|
  link   title
  parent :clients_show, client
end

crumb :clients_search do |table|
  link   "検索", "/bamember/clients/#{table.client.id}/table/#{table.id}/search"
  parent :clients_table, table
end

crumb :clients_data do |table, data|
  link   data[:name], "/bamember/clients/#{table.client.id}/table/#{table.id}/#{data.id}"
  parent :clients_search, table
end

crumb :clients_table_csv do |table|
  link   "インポート", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv"
  parent :clients_table, table
end

crumb :clients_table_csv_matching do |table|
  link   "マッチング", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv_matching"
  parent :clients_table_csv, table
end

crumb :clients_table_csv_confirm do |table|
  link   "確認", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv_confirm"
  parent :clients_table_csv_matching, table
end

crumb :clients_table_import do |table|
  link   "インポート", "/bamember/clients/#{table.client.id}/table/#{table.id}/import_file"
  parent :clients_table, table
end

crumb :clients_table_import_log do |table|
  link   "インポート履歴", "/bamember/clients/#{table.client.id}/table/#{table.id}/import_log"
  parent :clients_table, table
end

crumb :clients_table_import_matching do |csvfile|
  link   "マッチング", "/bamember/clients/#{csvfile.client_table.client_id}/table/#{csvfile.client_table_id}/import_matching/#{csvfile.id}"
  parent :clients_table_import, csvfile.client_table
end

crumb :clients_table_relation do |table|
  link   "リレーション", "/bamember/clients/#{table.client.id}/table/#{table.id}/relation"
  parent :clients_table, table
end

crumb :clients_table_relation_confirm do |table|
  link   "確認", "/bamember/clients/#{table.client.id}/table/#{table.id}/relation_confirm"
  parent :clients_table_relation, table
end

crumb :clients_table_something do |title, table|
  link   title
  parent :clients_table, table
end
