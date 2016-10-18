class RenameInfos < ActiveRecord::Migration
  def change
    rename_column :infos, :deleted_at, :soft_destroyed_at
  end
end
