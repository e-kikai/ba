class ClientColumnsChangeSummally < ActiveRecord::Migration
  def change
    change_column :client_columns, :sumally, :text, null: true
    rename_column :client_columns, :sumally, :comment2

    add_column :client_columns, :sumally, :boolean, null: false, default: false

  end
end
