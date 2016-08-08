# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160805085456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bamembers", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "role",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "soft_destroyed_at"
  end

  add_index "bamembers", ["email", "soft_destroyed_at"], name: "index_bamembers_on_email_and_soft_destroyed_at", unique: true, using: :btree
  add_index "bamembers", ["reset_password_token"], name: "index_bamembers_on_reset_password_token", unique: true, using: :btree
  add_index "bamembers", ["soft_destroyed_at"], name: "index_bamembers_on_soft_destroyed_at", using: :btree

  create_table "client_columns", force: :cascade do |t|
    t.string   "name",              default: "",     null: false
    t.string   "column_name",       default: "",     null: false
    t.string   "column_type"
    t.text     "selector"
    t.string   "default"
    t.boolean  "unique",            default: false,  null: false
    t.boolean  "presence",          default: false,  null: false
    t.boolean  "nochange",          default: false,  null: false
    t.boolean  "hidden",            default: false,  null: false
    t.text     "comment"
    t.integer  "client_table_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "soft_destroyed_at"
    t.integer  "order_no",          default: 999999, null: false
    t.text     "comment2"
    t.boolean  "sumally",           default: false,  null: false
    t.text     "ranges",            default: "",     null: false
  end

  add_index "client_columns", ["soft_destroyed_at"], name: "index_client_columns_on_soft_destroyed_at", using: :btree

  create_table "client_tables", force: :cascade do |t|
    t.string   "name",              default: "",     null: false
    t.string   "table_name",        default: "",     null: false
    t.integer  "client_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "soft_destroyed_at"
    t.integer  "order_no",          default: 999999, null: false
    t.boolean  "company",           default: false,  null: false
  end

  add_index "client_tables", ["soft_destroyed_at"], name: "index_client_tables_on_soft_destroyed_at", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",                   default: "",     null: false
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "soft_destroyed_at"
    t.integer  "order_no",               default: 999999, null: false
  end

  add_index "clients", ["email", "soft_destroyed_at"], name: "index_clients_on_email_and_soft_destroyed_at", unique: true, using: :btree
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
  add_index "clients", ["soft_destroyed_at"], name: "index_clients_on_soft_destroyed_at", using: :btree

  create_table "csvfiles", force: :cascade do |t|
    t.string   "path",              null: false
    t.string   "original_filename", null: false
    t.integer  "all_num"
    t.integer  "client_table_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
  end

  add_index "csvfiles", ["client_table_id"], name: "index_csvfiles_on_client_table_id", using: :btree

  create_table "dashboards", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "size"
    t.integer  "order_no"
    t.integer  "client_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.integer  "client_table_id"
  end

  add_index "dashboards", ["client_id"], name: "index_dashboards_on_client_id", using: :btree
  add_index "dashboards", ["client_table_id"], name: "index_dashboards_on_client_table_id", using: :btree

  create_table "imports", force: :cascade do |t|
    t.text     "matching_params"
    t.integer  "success_num"
    t.integer  "unmatch_num"
    t.integer  "overlap_num"
    t.integer  "error_num"
    t.text     "error_message"
    t.text     "errors_ids"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.datetime "uploaded_at"
    t.datetime "queued_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.datetime "rescued_at"
    t.integer  "csvfile_id"
  end

  add_index "imports", ["csvfile_id"], name: "index_imports_on_csvfile_id", using: :btree

  create_table "searchurls", force: :cascade do |t|
    t.string   "name"
    t.string   "target"
    t.integer  "size"
    t.integer  "order_no"
    t.boolean  "summary"
    t.integer  "client_table_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.text     "query"
  end

  add_index "searchurls", ["client_table_id"], name: "index_searchurls_on_client_table_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

end
