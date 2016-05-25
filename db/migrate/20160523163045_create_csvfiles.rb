class CreateCsvfiles < ActiveRecord::Migration
  def change
    create_table :csvfiles do |t|
      t.string     :path,              null: false
      t.string     :original_filename, null: false

      t.integer    :all_num

      t.belongs_to :client_table, index:true

      t.timestamps null: false
      t.datetime   :deleted_at
    end

    remove_column :imports, :path
    remove_column :imports, :original_filename
    remove_column :imports, :all_num
    remove_column :imports, :client_table_id

    rename_column :imports, :params, :matching_params
    add_column    :imports, :csvfile_id, :integer

    add_index     :imports, :csvfile_id
  end
end
