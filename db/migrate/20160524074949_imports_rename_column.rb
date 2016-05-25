class ImportsRenameColumn < ActiveRecord::Migration
  def change
    rename_column :imports,  :deleted_at, :soft_destroyed_at
    rename_column :csvfiles, :deleted_at, :soft_destroyed_at
  end
end
