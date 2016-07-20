class ChangeSearchurlsRenameActionToTarget < ActiveRecord::Migration
  def change
    rename_column :searchurls, :action, :target
  end
end
