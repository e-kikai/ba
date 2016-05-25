class ImportAddColumnQueuedAt < ActiveRecord::Migration
  def change
    rename_column :imports, :quered_at, :queued_at
  end
end
