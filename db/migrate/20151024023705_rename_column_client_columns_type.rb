class RenameColumnClientColumnsType < ActiveRecord::Migration
  def change
    rename_column :client_columns, :type, :column_type
  end
end
