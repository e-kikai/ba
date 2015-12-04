class ClientColumnsAddOrderNo < ActiveRecord::Migration
  def change
    add_column :clients,        :order_no, :integer, default: 999999, null: false
    add_column :client_tables,  :order_no, :integer, default: 999999, null: false
    add_column :client_columns, :order_no, :integer, default: 999999, null: false
  end
end
