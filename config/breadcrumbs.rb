# Root crumb
# crumb :root do
#   link "HOME", "/"
# end

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
  link   "#{table.name} 検索", "/bamember/clients/#{table.client.id}/table/#{table.id}/search"
  parent :clients_show, table.client
end

crumb :clients_data do |table, data|
  link   data.name, "/bamember/clients/#{table.client.id}/table/#{table.id}/#{data.id}"
  parent :clients_search, table
end

crumb :clients_table_csv do |table|
  link   "#{table.name} ファイルアップロード", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv"
  parent :clients_show, table.client
end

crumb :clients_table_csv_matching do |table|
  link   "マッチング", "/bamember/clients/#{table.client.id}/table/#{table.id}/csv_matching"
  parent :clients_table_csv, table
end
