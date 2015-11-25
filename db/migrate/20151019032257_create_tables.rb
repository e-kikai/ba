class CreateTables < ActiveRecord::Migration
  def change
    create_table :client_tables do |t|
      t.string     :name,       null: false, default: ""
      t.string     :table_name, null: false, default: ""
      t.belongs_to :client
      t.timestamps              null: false
      t.datetime   :deleted_at
    end
  end
end
