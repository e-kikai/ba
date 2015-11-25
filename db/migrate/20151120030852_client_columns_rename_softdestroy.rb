class ClientColumnsRenameSoftdestroy < ActiveRecord::Migration
  def change
    add_column    :clients, :soft_destroyed_at, :datetime
    rename_column :client_tables,  :deleted_at, :soft_destroyed_at
    rename_column :client_columns, :deleted_at, :soft_destroyed_at

    add_index :clients,        :soft_destroyed_at
    add_index :client_tables,  :soft_destroyed_at
    add_index :client_columns, :soft_destroyed_at
  end
end
