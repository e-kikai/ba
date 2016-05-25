class ImportAddColumnErrors < ActiveRecord::Migration
  def change
    rename_column :imports, :errors, :errors_ids 
  end
end
