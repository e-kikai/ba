# Root crumb
# crumb :root do
#   link "HOME", "/"
# end

### client ###
crumb :client_root do
  link "TOP", "/"
end

crumb :search do |table|
  link   "#{table.name}テーブル 検索", "/client_tables/#{table.id}/search"
  parent :client_root, table.client
end

crumb :data do |table, data|
  link   data.name, "/client_tables/#{table.id}/#{data.id}"
  parent :search, table
end

crumb :something do |title|
  link   title
  parent :client_root
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

crumb :clients_something do |title, client|
  link   title
  parent :clients_show, client
end

crumb :clients_search do |table|
  link   "#{table.name}テーブル 検索", "/bamember/clients/#{table.client.id}/table/#{table.id}/search"
  parent :clients_show, table.client
end

crumb :clients_data do |table, data|
  link   data.name, "/bamember/clients/#{table.client.id}/table/#{table.id}/#{data.id}"
  parent :clients_search, table
end

crumb :clients_table_csv do |table|
  link   "#{table.name}テーブル インポート", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv"
  parent :clients_show, table.client
end

crumb :clients_table_csv_matching do |table|
  link   "マッチング", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv_matching"
  parent :clients_table_csv, table
end

crumb :clients_table_csv_confirm do |table|
  link   "確認", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv_confirm"
  parent :clients_table_csv_matching, table
end

crumb :clients_table_relation do |table|
  link   "#{table.name}テーブル リレーション", "/bamember/clients/#{table.client.id}/table/#{table.id}/relation"
  parent :clients_show, table.client
end

crumb :clients_table_relation_confirm do |table|
  link   "確認", "/bamember/clients/#{table.client.id}/table/#{table.id}/relation_confirm"
  parent :clients_table_relation, table
end
