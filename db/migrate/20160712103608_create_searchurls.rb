class CreateSearchurls < ActiveRecord::Migration
  def change
    create_table :searchurls do |t|
      t.string     :name
      t.string     :url
      t.integer    :size
      t.integer    :order_no
      t.boolean    :summary
      t.belongs_to :client_table, index:true

      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end
  end
end
