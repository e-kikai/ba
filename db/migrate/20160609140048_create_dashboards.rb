class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string     :name
      t.string     :url
      t.integer    :size
      t.integer    :order_no
      t.belongs_to :client, index:true

      t.timestamps null: false
      t.datetime   :deleted_at
    end
  end
end
