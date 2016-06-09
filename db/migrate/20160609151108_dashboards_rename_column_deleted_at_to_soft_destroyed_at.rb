class DashboardsRenameColumnDeletedAtToSoftDestroyedAt < ActiveRecord::Migration
  def change
    rename_column :dashboards, :deleted_at, :soft_destroyed_at
  end
end
