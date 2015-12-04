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

ActiveRecord::Schema.define(version: 20151203081302) do

  create_table "c26_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
  end

  add_index "c26_companies", ["name"], name: "index_c26_companies_on_name"

  create_table "c26_persons", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
  end

  add_index "c26_persons", ["name"], name: "index_c26_persons_on_name"

  create_table "c27_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name"
    t.text     "co_20151120164951_23568"
    t.text     "co_20151120164951_82182"
    t.text     "co_20151122122324_53749"
    t.text     "co_20151202174325_72251", default: "", null: false
    t.text     "co_20151202174325_93365", default: "", null: false
    t.text     "co_20151203015047_48771", default: "", null: false
  end

  add_index "c27_companies", ["co_20151120164951_23568"], name: "index_c27_companies_on_co_20151120164951_23568"
  add_index "c27_companies", ["co_20151120164951_82182"], name: "index_c27_companies_on_co_20151120164951_82182"
  add_index "c27_companies", ["co_20151122122324_53749"], name: "index_c27_companies_on_co_20151122122324_53749"
  add_index "c27_companies", ["co_20151202174325_72251"], name: "index_c27_companies_on_co_20151202174325_72251"
  add_index "c27_companies", ["co_20151202174325_93365"], name: "index_c27_companies_on_co_20151202174325_93365"
  add_index "c27_companies", ["co_20151203015047_48771"], name: "index_c27_companies_on_co_20151203015047_48771"
  add_index "c27_companies", ["name"], name: "index_c27_companies_on_name"

  create_table "c27_people", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name"
    t.text     "co_20151124200756_41084", default: "", null: false
  end

  add_index "c27_people", ["co_20151124200756_41084"], name: "index_c27_people_on_co_20151124200756_41084"
  add_index "c27_people", ["name"], name: "index_c27_people_on_name"

  create_table "c_10_persons", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_10companies", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_11_companies", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_11_persons", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_12_companies", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_12_persons", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_13_companies", force: :cascade do |t|
    t.string   "aaaa\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_13_persons", force: :cascade do |t|
    t.string   "aaaa\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_14_companies", force: :cascade do |t|
    t.string "name"
  end

  create_table "c_14_persons", force: :cascade do |t|
    t.string "name"
  end

  create_table "c_15_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_15_persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_16_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_16_persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_17_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_17_persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_18_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_18_persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_19_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_19_persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_20_actions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_20_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_20_persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_21_actions", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
    t.string   "c_1445654739"
  end

  create_table "c_21_companies", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
    t.string   "c_1445654739"
  end

  create_table "c_21_persons", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
    t.string   "c_1445654739"
  end

  create_table "c_22_actions", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.string   "ClientTable"
  end

  create_table "c_22_companies", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.string   "ClientTable"
  end

  create_table "c_22_persons", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.string   "ClientTable"
  end

  create_table "c_23_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string   "name"
  end

  create_table "c_23_companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string   "name"
  end

  create_table "c_23_persons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string   "name"
  end

  create_table "c_24_actions", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.string   "co_1445835502"
  end

  create_table "c_24_companies", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.string   "co_1445835502"
    t.string   "co_1446095033"
    t.text     "co_1446109186"
    t.float    "co_1446623714"
    t.string   "co_1446803222"
    t.text     "co_1446803318"
  end

  add_index "c_24_companies", ["co_1446095033"], name: "index_c_24_companies_on_co_1446095033"
  add_index "c_24_companies", ["co_1446109186"], name: "index_c_24_companies_on_co_1446109186"
  add_index "c_24_companies", ["co_1446623714"], name: "index_c_24_companies_on_co_1446623714"
  add_index "c_24_companies", ["co_1446803222"], name: "index_c_24_companies_on_co_1446803222"
  add_index "c_24_companies", ["co_1446803318"], name: "index_c_24_companies_on_co_1446803318"

  create_table "c_24_persons", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.string   "co_1445835502"
  end

  create_table "c_25_companies", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.text     "co_20151109011323_34577"
    t.string   "co_20151109011323_18499"
    t.string   "co_20151109172317_5406"
    t.text     "co_20151118164815_48332"
    t.integer  "co_20151118164815_29932"
  end

  add_index "c_25_companies", ["co_20151109011323_18499"], name: "index_c_25_companies_on_co_20151109011323_18499"
  add_index "c_25_companies", ["co_20151109011323_34577"], name: "index_c_25_companies_on_co_20151109011323_34577"
  add_index "c_25_companies", ["co_20151109172317_5406"], name: "index_c_25_companies_on_co_20151109172317_5406"
  add_index "c_25_companies", ["co_20151118164815_29932"], name: "index_c_25_companies_on_co_20151118164815_29932"
  add_index "c_25_companies", ["co_20151118164815_48332"], name: "index_c_25_companies_on_co_20151118164815_48332"
  add_index "c_25_companies", ["name"], name: "index_c_25_companies_on_name"

  create_table "c_25_persons", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
  end

  add_index "c_25_persons", ["name"], name: "index_c_25_persons_on_name"

  create_table "c_2_companies", force: :cascade do |t|
    t.string   "name\u2028"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c_2_persons", force: :cascade do |t|
    t.string   "name\u2028"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c__companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "c__persons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

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
  end

  add_index "client_columns", ["soft_destroyed_at"], name: "index_client_columns_on_soft_destroyed_at"

  create_table "client_tables", force: :cascade do |t|
    t.string   "name",              default: "",     null: false
    t.string   "table_name",        default: "",     null: false
    t.integer  "client_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "soft_destroyed_at"
    t.integer  "order_no",          default: 999999, null: false
  end

  add_index "client_tables", ["soft_destroyed_at"], name: "index_client_tables_on_soft_destroyed_at"

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

  add_index "clients", ["email"], name: "index_clients_on_email", unique: true
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  add_index "clients", ["soft_destroyed_at"], name: "index_clients_on_soft_destroyed_at"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

end
