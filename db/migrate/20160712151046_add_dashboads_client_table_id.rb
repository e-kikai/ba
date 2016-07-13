class AddDashboadsClientTableId < ActiveRecord::Migration
  def change
    add_column :dashboards, :client_table_id,   :integer

    add_index  :dashboards, :client_table_id

    rename_column :searchurls, :url, :action
    
    add_column    :searchurls, :query,  :text
  end
end
