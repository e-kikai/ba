class ClientColumnsAddPresence < ActiveRecord::Migration
  def change
    rename_column :client_columns, :notnull, :presence
  end
end
