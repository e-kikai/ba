class ImportAddColumnQueredAt < ActiveRecord::Migration
  def change
    add_column :imports, :uploaded_at,  :datetime
    add_column :imports, :quered_at,    :datetime
    add_column :imports, :performed_at, :datetime
    add_column :imports, :finished_at,  :datetime
    add_column :imports, :rescued_at,   :datetime

    add_index  :imports, :client_table_id
  end
end
