class CreateClientColumns < ActiveRecord::Migration
  def change
    create_table :client_columns do |t|
      t.string     :name,        null: false, default: ""
      t.string     :column_name, null: false, default: ""
      t.string     :type
      t.text       :selector
      t.string     :default
      t.boolean    :unique,      null: false, default: false
      t.boolean    :notnull,     null: false, default: false
      t.boolean    :nochange,    null: false, default: false
      t.boolean    :hidden,      null: false, default: false
      t.text       :comment
      t.belongs_to :client_table
      t.timestamps               null: false
      t.datetime   :deleted_at
    end
  end
end
