class ClientTablesAddColumnIsCompany < ActiveRecord::Migration
  def change
    add_column :client_tables, :company, :boolean, null: false, default: false

    add_column :client_columns, :ranges, :text, null: false, default: ""
  end
end
