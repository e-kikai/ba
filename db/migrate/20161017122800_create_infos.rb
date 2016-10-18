class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.text       :content
      t.belongs_to :client, index: true

      t.timestamps null: false
      t.datetime   :deleted_at, index: true
    end

    add_column :searchurls, :comment, :text
  end
end
