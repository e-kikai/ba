class ClientColumnsAddSummally < ActiveRecord::Migration
  def change
    add_column :client_columns, :sumally, :integer
  end
end
