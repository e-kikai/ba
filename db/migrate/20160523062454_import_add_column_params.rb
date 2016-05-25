class ImportAddColumnParams < ActiveRecord::Migration
  create_table :imports do |t|
    t.string     :path
    t.string     :original_filename

    t.text       :params

    t.integer    :all_num
    t.integer    :success_num
    t.integer    :unmatch_num
    t.integer    :overlap_num
    t.integer    :error_num

    t.text       :error_message

    t.text       :errors

    t.belongs_to :client_table

    t.timestamps               null: false
    t.datetime   :deleted_at
  end
end
