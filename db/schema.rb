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

ActiveRecord::Schema.define(version: 20160524074949) do

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

  add_index "bamembers", ["email"], name: "index_bamembers_on_email", unique: true, using: :btree
  add_index "bamembers", ["reset_password_token"], name: "index_bamembers_on_reset_password_token", unique: true, using: :btree
  add_index "bamembers", ["soft_destroyed_at"], name: "index_bamembers_on_soft_destroyed_at", using: :btree

  create_table "c10_companies", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c10_companies", ["name"], name: "index_c10_companies_on_name", using: :btree

  create_table "c10_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c10_people", ["name"], name: "index_c10_people_on_name", using: :btree

  create_table "c11_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20160112162040_71595", default: "", null: false
    t.text     "co_20160112162040_2204",  default: "", null: false
    t.text     "co_20160112162040_36794", default: "", null: false
    t.text     "co_20160112162040_51552", default: "", null: false
    t.text     "co_20160112162040_56213", default: "", null: false
    t.text     "co_20160112162040_27878", default: "", null: false
    t.text     "co_20160112162040_7675",  default: "", null: false
    t.text     "co_20160112162040_71492", default: "", null: false
    t.text     "co_20160112162040_42082", default: "", null: false
    t.text     "co_20160112162040_56292", default: "", null: false
    t.text     "co_20160112162040_86901", default: "", null: false
    t.text     "co_20160112162040_93871", default: "", null: false
    t.text     "co_20160112162040_10685", default: "", null: false
    t.text     "co_20160113114625_69017", default: "", null: false
    t.text     "co_20160113114625_96401", default: "", null: false
    t.text     "co_20160113114625_59776", default: "", null: false
  end

  add_index "c11_companies", ["co_20160112162040_10685"], name: "index_c11_companies_on_co_20160112162040_10685", using: :btree
  add_index "c11_companies", ["co_20160112162040_2204"], name: "index_c11_companies_on_co_20160112162040_2204", using: :btree
  add_index "c11_companies", ["co_20160112162040_27878"], name: "index_c11_companies_on_co_20160112162040_27878", using: :btree
  add_index "c11_companies", ["co_20160112162040_36794"], name: "index_c11_companies_on_co_20160112162040_36794", using: :btree
  add_index "c11_companies", ["co_20160112162040_42082"], name: "index_c11_companies_on_co_20160112162040_42082", using: :btree
  add_index "c11_companies", ["co_20160112162040_51552"], name: "index_c11_companies_on_co_20160112162040_51552", using: :btree
  add_index "c11_companies", ["co_20160112162040_56213"], name: "index_c11_companies_on_co_20160112162040_56213", using: :btree
  add_index "c11_companies", ["co_20160112162040_56292"], name: "index_c11_companies_on_co_20160112162040_56292", using: :btree
  add_index "c11_companies", ["co_20160112162040_71492"], name: "index_c11_companies_on_co_20160112162040_71492", using: :btree
  add_index "c11_companies", ["co_20160112162040_71595"], name: "index_c11_companies_on_co_20160112162040_71595", using: :btree
  add_index "c11_companies", ["co_20160112162040_7675"], name: "index_c11_companies_on_co_20160112162040_7675", using: :btree
  add_index "c11_companies", ["co_20160112162040_86901"], name: "index_c11_companies_on_co_20160112162040_86901", using: :btree
  add_index "c11_companies", ["co_20160112162040_93871"], name: "index_c11_companies_on_co_20160112162040_93871", using: :btree
  add_index "c11_companies", ["co_20160113114625_59776"], name: "index_c11_companies_on_co_20160113114625_59776", using: :btree
  add_index "c11_companies", ["co_20160113114625_69017"], name: "index_c11_companies_on_co_20160113114625_69017", using: :btree
  add_index "c11_companies", ["co_20160113114625_96401"], name: "index_c11_companies_on_co_20160113114625_96401", using: :btree
  add_index "c11_companies", ["name"], name: "index_c11_companies_on_name", using: :btree

  create_table "c11_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c11_people", ["name"], name: "index_c11_people_on_name", using: :btree

  create_table "c12_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20160113133335_63208", default: "", null: false
    t.text     "co_20160113133335_25158", default: "", null: false
    t.text     "co_20160113133335_92308", default: "", null: false
    t.text     "co_20160113133335_55292", default: "", null: false
    t.text     "co_20160113133335_27331", default: "", null: false
    t.text     "co_20160113133335_40604", default: "", null: false
    t.text     "co_20160113133335_69971", default: "", null: false
    t.text     "co_20160113133335_37799", default: "", null: false
    t.text     "co_20160113133335_81558", default: "", null: false
    t.text     "co_20160113133335_2096",  default: "", null: false
    t.text     "co_20160113133335_14048", default: "", null: false
    t.text     "co_20160113133335_38217", default: "", null: false
    t.text     "co_20160113133335_40754", default: "", null: false
    t.text     "co_20160113160005_22033", default: "", null: false
    t.text     "co_20160113160005_8999",  default: "", null: false
    t.text     "co_20160113160005_81105", default: "", null: false
  end

  add_index "c12_companies", ["co_20160113133335_14048"], name: "index_c12_companies_on_co_20160113133335_14048", using: :btree
  add_index "c12_companies", ["co_20160113133335_2096"], name: "index_c12_companies_on_co_20160113133335_2096", using: :btree
  add_index "c12_companies", ["co_20160113133335_25158"], name: "index_c12_companies_on_co_20160113133335_25158", using: :btree
  add_index "c12_companies", ["co_20160113133335_27331"], name: "index_c12_companies_on_co_20160113133335_27331", using: :btree
  add_index "c12_companies", ["co_20160113133335_37799"], name: "index_c12_companies_on_co_20160113133335_37799", using: :btree
  add_index "c12_companies", ["co_20160113133335_38217"], name: "index_c12_companies_on_co_20160113133335_38217", using: :btree
  add_index "c12_companies", ["co_20160113133335_40604"], name: "index_c12_companies_on_co_20160113133335_40604", using: :btree
  add_index "c12_companies", ["co_20160113133335_40754"], name: "index_c12_companies_on_co_20160113133335_40754", using: :btree
  add_index "c12_companies", ["co_20160113133335_55292"], name: "index_c12_companies_on_co_20160113133335_55292", using: :btree
  add_index "c12_companies", ["co_20160113133335_63208"], name: "index_c12_companies_on_co_20160113133335_63208", using: :btree
  add_index "c12_companies", ["co_20160113133335_69971"], name: "index_c12_companies_on_co_20160113133335_69971", using: :btree
  add_index "c12_companies", ["co_20160113133335_81558"], name: "index_c12_companies_on_co_20160113133335_81558", using: :btree
  add_index "c12_companies", ["co_20160113133335_92308"], name: "index_c12_companies_on_co_20160113133335_92308", using: :btree
  add_index "c12_companies", ["co_20160113160005_22033"], name: "index_c12_companies_on_co_20160113160005_22033", using: :btree
  add_index "c12_companies", ["co_20160113160005_81105"], name: "index_c12_companies_on_co_20160113160005_81105", using: :btree
  add_index "c12_companies", ["co_20160113160005_8999"], name: "index_c12_companies_on_co_20160113160005_8999", using: :btree
  add_index "c12_companies", ["name"], name: "index_c12_companies_on_name", using: :btree

  create_table "c12_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c12_people", ["name"], name: "index_c12_people_on_name", using: :btree

  create_table "c13_companies", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c13_companies", ["name"], name: "index_c13_companies_on_name", using: :btree

  create_table "c13_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c13_people", ["name"], name: "index_c13_people_on_name", using: :btree

  create_table "c14_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20160201160103_32599", default: "", null: false
    t.text     "co_20160201160103_2108",  default: "", null: false
    t.text     "co_20160201160103_26312", default: "", null: false
    t.text     "co_20160201160103_7942",  default: "", null: false
    t.text     "co_20160201160103_45065", default: "", null: false
    t.text     "co_20160201160103_24157", default: "", null: false
    t.text     "co_20160201160103_77414", default: "", null: false
    t.text     "co_20160201160103_52130", default: "", null: false
    t.text     "co_20160201160103_92488", default: "", null: false
    t.text     "co_20160201160103_15941", default: "", null: false
    t.text     "co_20160201160103_13989", default: "", null: false
    t.text     "co_20160201160103_36021", default: "", null: false
    t.text     "co_20160201160103_89095", default: "", null: false
  end

  add_index "c14_companies", ["co_20160201160103_13989"], name: "index_c14_companies_on_co_20160201160103_13989", using: :btree
  add_index "c14_companies", ["co_20160201160103_15941"], name: "index_c14_companies_on_co_20160201160103_15941", using: :btree
  add_index "c14_companies", ["co_20160201160103_2108"], name: "index_c14_companies_on_co_20160201160103_2108", using: :btree
  add_index "c14_companies", ["co_20160201160103_24157"], name: "index_c14_companies_on_co_20160201160103_24157", using: :btree
  add_index "c14_companies", ["co_20160201160103_26312"], name: "index_c14_companies_on_co_20160201160103_26312", using: :btree
  add_index "c14_companies", ["co_20160201160103_32599"], name: "index_c14_companies_on_co_20160201160103_32599", using: :btree
  add_index "c14_companies", ["co_20160201160103_36021"], name: "index_c14_companies_on_co_20160201160103_36021", using: :btree
  add_index "c14_companies", ["co_20160201160103_45065"], name: "index_c14_companies_on_co_20160201160103_45065", using: :btree
  add_index "c14_companies", ["co_20160201160103_52130"], name: "index_c14_companies_on_co_20160201160103_52130", using: :btree
  add_index "c14_companies", ["co_20160201160103_77414"], name: "index_c14_companies_on_co_20160201160103_77414", using: :btree
  add_index "c14_companies", ["co_20160201160103_7942"], name: "index_c14_companies_on_co_20160201160103_7942", using: :btree
  add_index "c14_companies", ["co_20160201160103_89095"], name: "index_c14_companies_on_co_20160201160103_89095", using: :btree
  add_index "c14_companies", ["co_20160201160103_92488"], name: "index_c14_companies_on_co_20160201160103_92488", using: :btree
  add_index "c14_companies", ["name"], name: "index_c14_companies_on_name", using: :btree

  create_table "c14_people", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20160201160239_978",   default: "", null: false
    t.text     "co_20160201160239_54299", default: "", null: false
    t.text     "co_20160201160239_89691", default: "", null: false
  end

  add_index "c14_people", ["co_20160201160239_54299"], name: "index_c14_people_on_co_20160201160239_54299", using: :btree
  add_index "c14_people", ["co_20160201160239_89691"], name: "index_c14_people_on_co_20160201160239_89691", using: :btree
  add_index "c14_people", ["co_20160201160239_978"], name: "index_c14_people_on_co_20160201160239_978", using: :btree
  add_index "c14_people", ["name"], name: "index_c14_people_on_name", using: :btree

  create_table "c15_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151225164530_33323", default: "", null: false
    t.text     "co_20151225163928_40939", default: "", null: false
    t.text     "co_20151225163928_74804", default: "", null: false
    t.text     "co_20151225163928_17737", default: "", null: false
    t.text     "co_20151225163928_64328", default: "", null: false
    t.text     "co_20151225163928_77386", default: "", null: false
    t.text     "co_20151225163928_71061", default: "", null: false
    t.text     "co_20151225163928_13156", default: "", null: false
    t.text     "co_20151225163928_35669", default: "", null: false
    t.text     "co_20151225163928_51066", default: "", null: false
    t.text     "co_20151225163928_75316", default: "", null: false
    t.text     "co_20151225163928_41514", default: "", null: false
    t.text     "co_20151225163928_5840",  default: "", null: false
    t.text     "co_20151225163928_64029", default: "", null: false
    t.text     "co_20151225163928_36354", default: "", null: false
    t.text     "co_20151225163928_75089", default: "", null: false
    t.text     "co_20151225163928_18218", default: "", null: false
    t.text     "co_20151225163928_6457",  default: "", null: false
    t.text     "co_20151225163928_9439",  default: "", null: false
    t.text     "co_20151225163928_40831", default: "", null: false
    t.text     "co_20151225170838_57969", default: "", null: false
    t.text     "co_20151225170838_86398", default: "", null: false
    t.text     "co_20151225170838_59411", default: "", null: false
    t.text     "co_20160226144518_73806", default: "", null: false
    t.text     "co_20160226144752_97838", default: "", null: false
  end

  add_index "c15_companies", ["co_20151225163928_13156"], name: "index_c15_companies_on_co_20151225163928_13156", using: :btree
  add_index "c15_companies", ["co_20151225163928_17737"], name: "index_c15_companies_on_co_20151225163928_17737", using: :btree
  add_index "c15_companies", ["co_20151225163928_18218"], name: "index_c15_companies_on_co_20151225163928_18218", using: :btree
  add_index "c15_companies", ["co_20151225163928_35669"], name: "index_c15_companies_on_co_20151225163928_35669", using: :btree
  add_index "c15_companies", ["co_20151225163928_36354"], name: "index_c15_companies_on_co_20151225163928_36354", using: :btree
  add_index "c15_companies", ["co_20151225163928_40831"], name: "index_c15_companies_on_co_20151225163928_40831", using: :btree
  add_index "c15_companies", ["co_20151225163928_40939"], name: "index_c15_companies_on_co_20151225163928_40939", using: :btree
  add_index "c15_companies", ["co_20151225163928_41514"], name: "index_c15_companies_on_co_20151225163928_41514", using: :btree
  add_index "c15_companies", ["co_20151225163928_51066"], name: "index_c15_companies_on_co_20151225163928_51066", using: :btree
  add_index "c15_companies", ["co_20151225163928_5840"], name: "index_c15_companies_on_co_20151225163928_5840", using: :btree
  add_index "c15_companies", ["co_20151225163928_64029"], name: "index_c15_companies_on_co_20151225163928_64029", using: :btree
  add_index "c15_companies", ["co_20151225163928_64328"], name: "index_c15_companies_on_co_20151225163928_64328", using: :btree
  add_index "c15_companies", ["co_20151225163928_6457"], name: "index_c15_companies_on_co_20151225163928_6457", using: :btree
  add_index "c15_companies", ["co_20151225163928_71061"], name: "index_c15_companies_on_co_20151225163928_71061", using: :btree
  add_index "c15_companies", ["co_20151225163928_74804"], name: "index_c15_companies_on_co_20151225163928_74804", using: :btree
  add_index "c15_companies", ["co_20151225163928_75089"], name: "index_c15_companies_on_co_20151225163928_75089", using: :btree
  add_index "c15_companies", ["co_20151225163928_75316"], name: "index_c15_companies_on_co_20151225163928_75316", using: :btree
  add_index "c15_companies", ["co_20151225163928_77386"], name: "index_c15_companies_on_co_20151225163928_77386", using: :btree
  add_index "c15_companies", ["co_20151225163928_9439"], name: "index_c15_companies_on_co_20151225163928_9439", using: :btree
  add_index "c15_companies", ["co_20151225164530_33323"], name: "index_c15_companies_on_co_20151225164530_33323", using: :btree
  add_index "c15_companies", ["co_20151225170838_57969"], name: "index_c15_companies_on_co_20151225170838_57969", using: :btree
  add_index "c15_companies", ["co_20151225170838_59411"], name: "index_c15_companies_on_co_20151225170838_59411", using: :btree
  add_index "c15_companies", ["co_20151225170838_86398"], name: "index_c15_companies_on_co_20151225170838_86398", using: :btree
  add_index "c15_companies", ["co_20160226144518_73806"], name: "index_c15_companies_on_co_20160226144518_73806", using: :btree
  add_index "c15_companies", ["co_20160226144752_97838"], name: "index_c15_companies_on_co_20160226144752_97838", using: :btree
  add_index "c15_companies", ["name"], name: "index_c15_companies_on_name", using: :btree

  create_table "c15_people", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151225184610_82649", default: "", null: false
    t.text     "co_20151225184610_24757", default: "", null: false
    t.text     "co_20151225184610_38856", default: "", null: false
    t.text     "co_20151225184610_45139", default: "", null: false
    t.text     "co_20151225184610_38284", default: "", null: false
    t.text     "co_20151225184610_48782", default: "", null: false
    t.text     "co_20151225184610_89963", default: "", null: false
    t.text     "co_20151225184610_6044",  default: "", null: false
    t.text     "co_20151225184610_70938", default: "", null: false
    t.text     "co_20151225184610_37950", default: "", null: false
    t.text     "co_20151225184723_43109", default: "", null: false
  end

  add_index "c15_people", ["co_20151225184610_24757"], name: "index_c15_people_on_co_20151225184610_24757", using: :btree
  add_index "c15_people", ["co_20151225184610_37950"], name: "index_c15_people_on_co_20151225184610_37950", using: :btree
  add_index "c15_people", ["co_20151225184610_38284"], name: "index_c15_people_on_co_20151225184610_38284", using: :btree
  add_index "c15_people", ["co_20151225184610_38856"], name: "index_c15_people_on_co_20151225184610_38856", using: :btree
  add_index "c15_people", ["co_20151225184610_45139"], name: "index_c15_people_on_co_20151225184610_45139", using: :btree
  add_index "c15_people", ["co_20151225184610_48782"], name: "index_c15_people_on_co_20151225184610_48782", using: :btree
  add_index "c15_people", ["co_20151225184610_6044"], name: "index_c15_people_on_co_20151225184610_6044", using: :btree
  add_index "c15_people", ["co_20151225184610_70938"], name: "index_c15_people_on_co_20151225184610_70938", using: :btree
  add_index "c15_people", ["co_20151225184610_82649"], name: "index_c15_people_on_co_20151225184610_82649", using: :btree
  add_index "c15_people", ["co_20151225184610_89963"], name: "index_c15_people_on_co_20151225184610_89963", using: :btree
  add_index "c15_people", ["co_20151225184723_43109"], name: "index_c15_people_on_co_20151225184723_43109", using: :btree
  add_index "c15_people", ["name"], name: "index_c15_people_on_name", using: :btree

  create_table "c16_20160311031446_31251", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
    t.text     "company_id",        default: "", null: false
  end

  add_index "c16_20160311031446_31251", ["company_id"], name: "index_c16_20160311031446_31251_on_company_id", using: :btree
  add_index "c16_20160311031446_31251", ["name"], name: "index_c16_20160311031446_31251_on_name", using: :btree

  create_table "c16_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20160228033730_358",   default: "", null: false
    t.text     "co_20160321104315_76018", default: "", null: false
    t.string   "co_20160321105803_268",   default: "", null: false
    t.text     "co_20160321114900_662",   default: "", null: false
    t.text     "co_20160321152353_473",   default: "", null: false
    t.text     "co_20160321163159_191",   default: "", null: false
    t.text     "co_20160321163159_153",   default: "", null: false
    t.string   "co_20160321182724_208"
    t.string   "co_20160321182900_409"
    t.float    "co_20160322001141_58"
    t.datetime "co_20160322001141_591"
    t.integer  "co_20160322001859_451"
  end

  add_index "c16_companies", ["co_20160228033730_358"], name: "index_c16_companies_on_co_20160228033730_358", using: :btree
  add_index "c16_companies", ["co_20160321104315_76018"], name: "index_c16_companies_on_co_20160321104315_76018", using: :btree
  add_index "c16_companies", ["co_20160321105803_268"], name: "index_c16_companies_on_co_20160321105803_268", using: :btree
  add_index "c16_companies", ["co_20160321114900_662"], name: "index_c16_companies_on_co_20160321114900_662", using: :btree
  add_index "c16_companies", ["co_20160321152353_473"], name: "index_c16_companies_on_co_20160321152353_473", using: :btree
  add_index "c16_companies", ["co_20160321163159_153"], name: "index_c16_companies_on_co_20160321163159_153", using: :btree
  add_index "c16_companies", ["co_20160321163159_191"], name: "index_c16_companies_on_co_20160321163159_191", using: :btree
  add_index "c16_companies", ["co_20160321182724_208"], name: "index_c16_companies_on_co_20160321182724_208", using: :btree
  add_index "c16_companies", ["co_20160321182900_409"], name: "index_c16_companies_on_co_20160321182900_409", using: :btree
  add_index "c16_companies", ["co_20160322001141_58"], name: "index_c16_companies_on_co_20160322001141_58", using: :btree
  add_index "c16_companies", ["co_20160322001141_591"], name: "index_c16_companies_on_co_20160322001141_591", using: :btree
  add_index "c16_companies", ["co_20160322001859_451"], name: "index_c16_companies_on_co_20160322001859_451", using: :btree
  add_index "c16_companies", ["name"], name: "index_c16_companies_on_name", using: :btree

  create_table "c17_20160322121003_45205", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160322181120_881"
    t.string   "co_20160329131337_455"
    t.string   "co_20160329131337_87"
    t.integer  "co_20160329143810_614"
    t.float    "co_20160329143810_362"
    t.datetime "co_20160329143810_893"
    t.string   "co_20160401164125_966"
    t.string   "co_20160401182346_263"
  end

  add_index "c17_20160322121003_45205", ["co_20160322181120_881"], name: "index_c17_20160322121003_45205_on_co_20160322181120_881", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160329131337_455"], name: "index_c17_20160322121003_45205_on_co_20160329131337_455", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160329131337_87"], name: "index_c17_20160322121003_45205_on_co_20160329131337_87", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160329143810_362"], name: "index_c17_20160322121003_45205_on_co_20160329143810_362", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160329143810_614"], name: "index_c17_20160322121003_45205_on_co_20160329143810_614", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160329143810_893"], name: "index_c17_20160322121003_45205_on_co_20160329143810_893", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160401164125_966"], name: "index_c17_20160322121003_45205_on_co_20160401164125_966", using: :btree
  add_index "c17_20160322121003_45205", ["co_20160401182346_263"], name: "index_c17_20160322121003_45205_on_co_20160401182346_263", using: :btree
  add_index "c17_20160322121003_45205", ["company_id"], name: "index_c17_20160322121003_45205_on_company_id", using: :btree
  add_index "c17_20160322121003_45205", ["name"], name: "index_c17_20160322121003_45205_on_name", using: :btree

  create_table "c17_20160324171635_575", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160411153558_70"
  end

  add_index "c17_20160324171635_575", ["co_20160411153558_70"], name: "index_c17_20160324171635_575_on_co_20160411153558_70", using: :btree
  add_index "c17_20160324171635_575", ["company_id"], name: "index_c17_20160324171635_575_on_company_id", using: :btree
  add_index "c17_20160324171635_575", ["name"], name: "index_c17_20160324171635_575_on_name", using: :btree

  create_table "c17_companies", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
    t.text     "pref",              default: "", null: false
    t.text     "tel",               default: "", null: false
    t.text     "fax",               default: "", null: false
    t.text     "zip",               default: "", null: false
    t.text     "address",           default: "", null: false
    t.text     "mail",              default: "", null: false
    t.text     "url",               default: "", null: false
    t.text     "status",            default: "", null: false
    t.text     "target",            default: "", null: false
    t.text     "influx",            default: "", null: false
  end

  add_index "c17_companies", ["address"], name: "index_c17_companies_on_address", using: :btree
  add_index "c17_companies", ["fax"], name: "index_c17_companies_on_fax", using: :btree
  add_index "c17_companies", ["influx"], name: "index_c17_companies_on_influx", using: :btree
  add_index "c17_companies", ["mail"], name: "index_c17_companies_on_mail", using: :btree
  add_index "c17_companies", ["name"], name: "index_c17_companies_on_name", using: :btree
  add_index "c17_companies", ["pref"], name: "index_c17_companies_on_pref", using: :btree
  add_index "c17_companies", ["status"], name: "index_c17_companies_on_status", using: :btree
  add_index "c17_companies", ["target"], name: "index_c17_companies_on_target", using: :btree
  add_index "c17_companies", ["tel"], name: "index_c17_companies_on_tel", using: :btree
  add_index "c17_companies", ["url"], name: "index_c17_companies_on_url", using: :btree
  add_index "c17_companies", ["zip"], name: "index_c17_companies_on_zip", using: :btree

  create_table "c18_20160324170707_417", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
  end

  add_index "c18_20160324170707_417", ["company_id"], name: "index_c18_20160324170707_417_on_company_id", using: :btree
  add_index "c18_20160324170707_417", ["name"], name: "index_c18_20160324170707_417_on_name", using: :btree

  create_table "c18_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c18_companies", ["address"], name: "index_c18_companies_on_address", using: :btree
  add_index "c18_companies", ["fax"], name: "index_c18_companies_on_fax", using: :btree
  add_index "c18_companies", ["influx"], name: "index_c18_companies_on_influx", using: :btree
  add_index "c18_companies", ["mail"], name: "index_c18_companies_on_mail", using: :btree
  add_index "c18_companies", ["name"], name: "index_c18_companies_on_name", using: :btree
  add_index "c18_companies", ["pref"], name: "index_c18_companies_on_pref", using: :btree
  add_index "c18_companies", ["status"], name: "index_c18_companies_on_status", using: :btree
  add_index "c18_companies", ["target"], name: "index_c18_companies_on_target", using: :btree
  add_index "c18_companies", ["tel"], name: "index_c18_companies_on_tel", using: :btree
  add_index "c18_companies", ["url"], name: "index_c18_companies_on_url", using: :btree
  add_index "c18_companies", ["zip"], name: "index_c18_companies_on_zip", using: :btree

  create_table "c1_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151126024103_34241", default: "", null: false
  end

  add_index "c1_companies", ["co_20151126024103_34241"], name: "index_c1_companies_on_co_20151126024103_34241", using: :btree
  add_index "c1_companies", ["name"], name: "index_c1_companies_on_name", using: :btree

  create_table "c1_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c1_people", ["name"], name: "index_c1_people_on_name", using: :btree

  create_table "c21_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c21_companies", ["address"], name: "index_c21_companies_on_address", using: :btree
  add_index "c21_companies", ["fax"], name: "index_c21_companies_on_fax", using: :btree
  add_index "c21_companies", ["influx"], name: "index_c21_companies_on_influx", using: :btree
  add_index "c21_companies", ["mail"], name: "index_c21_companies_on_mail", using: :btree
  add_index "c21_companies", ["name"], name: "index_c21_companies_on_name", using: :btree
  add_index "c21_companies", ["pref"], name: "index_c21_companies_on_pref", using: :btree
  add_index "c21_companies", ["status"], name: "index_c21_companies_on_status", using: :btree
  add_index "c21_companies", ["target"], name: "index_c21_companies_on_target", using: :btree
  add_index "c21_companies", ["tel"], name: "index_c21_companies_on_tel", using: :btree
  add_index "c21_companies", ["url"], name: "index_c21_companies_on_url", using: :btree
  add_index "c21_companies", ["zip"], name: "index_c21_companies_on_zip", using: :btree

  create_table "c22_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c22_companies", ["address"], name: "index_c22_companies_on_address", using: :btree
  add_index "c22_companies", ["fax"], name: "index_c22_companies_on_fax", using: :btree
  add_index "c22_companies", ["influx"], name: "index_c22_companies_on_influx", using: :btree
  add_index "c22_companies", ["mail"], name: "index_c22_companies_on_mail", using: :btree
  add_index "c22_companies", ["name"], name: "index_c22_companies_on_name", using: :btree
  add_index "c22_companies", ["pref"], name: "index_c22_companies_on_pref", using: :btree
  add_index "c22_companies", ["status"], name: "index_c22_companies_on_status", using: :btree
  add_index "c22_companies", ["target"], name: "index_c22_companies_on_target", using: :btree
  add_index "c22_companies", ["tel"], name: "index_c22_companies_on_tel", using: :btree
  add_index "c22_companies", ["url"], name: "index_c22_companies_on_url", using: :btree
  add_index "c22_companies", ["zip"], name: "index_c22_companies_on_zip", using: :btree

  create_table "c28_20160322121003_45205", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160329131337_455"
    t.string   "co_20160329131337_87"
    t.float    "co_20160329143810_362"
    t.datetime "co_20160329143810_893"
    t.integer  "co_20160329143810_614"
    t.string   "co_20160401164125_966"
    t.string   "co_20160401182346_263"
    t.text     "co_20160322181120_881"
  end

  add_index "c28_20160322121003_45205", ["co_20160322181120_881"], name: "index_c28_20160322121003_45205_on_co_20160322181120_881", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160329131337_455"], name: "index_c28_20160322121003_45205_on_co_20160329131337_455", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160329131337_87"], name: "index_c28_20160322121003_45205_on_co_20160329131337_87", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160329143810_362"], name: "index_c28_20160322121003_45205_on_co_20160329143810_362", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160329143810_614"], name: "index_c28_20160322121003_45205_on_co_20160329143810_614", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160329143810_893"], name: "index_c28_20160322121003_45205_on_co_20160329143810_893", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160401164125_966"], name: "index_c28_20160322121003_45205_on_co_20160401164125_966", using: :btree
  add_index "c28_20160322121003_45205", ["co_20160401182346_263"], name: "index_c28_20160322121003_45205_on_co_20160401182346_263", using: :btree
  add_index "c28_20160322121003_45205", ["company_id"], name: "index_c28_20160322121003_45205_on_company_id", using: :btree
  add_index "c28_20160322121003_45205", ["name"], name: "index_c28_20160322121003_45205_on_name", using: :btree

  create_table "c28_20160324171635_575", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160411153558_70"
  end

  add_index "c28_20160324171635_575", ["co_20160411153558_70"], name: "index_c28_20160324171635_575_on_co_20160411153558_70", using: :btree
  add_index "c28_20160324171635_575", ["company_id"], name: "index_c28_20160324171635_575_on_company_id", using: :btree
  add_index "c28_20160324171635_575", ["name"], name: "index_c28_20160324171635_575_on_name", using: :btree

  create_table "c28_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c28_companies", ["address"], name: "index_c28_companies_on_address", using: :btree
  add_index "c28_companies", ["fax"], name: "index_c28_companies_on_fax", using: :btree
  add_index "c28_companies", ["influx"], name: "index_c28_companies_on_influx", using: :btree
  add_index "c28_companies", ["mail"], name: "index_c28_companies_on_mail", using: :btree
  add_index "c28_companies", ["name"], name: "index_c28_companies_on_name", using: :btree
  add_index "c28_companies", ["pref"], name: "index_c28_companies_on_pref", using: :btree
  add_index "c28_companies", ["status"], name: "index_c28_companies_on_status", using: :btree
  add_index "c28_companies", ["target"], name: "index_c28_companies_on_target", using: :btree
  add_index "c28_companies", ["tel"], name: "index_c28_companies_on_tel", using: :btree
  add_index "c28_companies", ["url"], name: "index_c28_companies_on_url", using: :btree
  add_index "c28_companies", ["zip"], name: "index_c28_companies_on_zip", using: :btree

  create_table "c29_20160322121003_45205", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160329131337_455"
    t.string   "co_20160329131337_87"
    t.float    "co_20160329143810_362"
    t.datetime "co_20160329143810_893"
    t.integer  "co_20160329143810_614"
    t.string   "co_20160401164125_966"
    t.string   "co_20160401182346_263"
    t.text     "co_20160322181120_881"
  end

  add_index "c29_20160322121003_45205", ["co_20160322181120_881"], name: "index_c29_20160322121003_45205_on_co_20160322181120_881", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160329131337_455"], name: "index_c29_20160322121003_45205_on_co_20160329131337_455", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160329131337_87"], name: "index_c29_20160322121003_45205_on_co_20160329131337_87", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160329143810_362"], name: "index_c29_20160322121003_45205_on_co_20160329143810_362", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160329143810_614"], name: "index_c29_20160322121003_45205_on_co_20160329143810_614", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160329143810_893"], name: "index_c29_20160322121003_45205_on_co_20160329143810_893", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160401164125_966"], name: "index_c29_20160322121003_45205_on_co_20160401164125_966", using: :btree
  add_index "c29_20160322121003_45205", ["co_20160401182346_263"], name: "index_c29_20160322121003_45205_on_co_20160401182346_263", using: :btree
  add_index "c29_20160322121003_45205", ["company_id"], name: "index_c29_20160322121003_45205_on_company_id", using: :btree
  add_index "c29_20160322121003_45205", ["name"], name: "index_c29_20160322121003_45205_on_name", using: :btree

  create_table "c29_20160324171635_575", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160411153558_70"
    t.string   "co_20160413141018_498"
    t.string   "co_20160413141018_218"
    t.string   "co_20160413141745_398"
    t.integer  "co_20160413150827_941"
    t.float    "co_20160413150827_16"
  end

  add_index "c29_20160324171635_575", ["co_20160411153558_70"], name: "index_c29_20160324171635_575_on_co_20160411153558_70", using: :btree
  add_index "c29_20160324171635_575", ["co_20160413141018_218"], name: "index_c29_20160324171635_575_on_co_20160413141018_218", using: :btree
  add_index "c29_20160324171635_575", ["co_20160413141018_498"], name: "index_c29_20160324171635_575_on_co_20160413141018_498", using: :btree
  add_index "c29_20160324171635_575", ["co_20160413141745_398"], name: "index_c29_20160324171635_575_on_co_20160413141745_398", using: :btree
  add_index "c29_20160324171635_575", ["co_20160413150827_16"], name: "index_c29_20160324171635_575_on_co_20160413150827_16", using: :btree
  add_index "c29_20160324171635_575", ["co_20160413150827_941"], name: "index_c29_20160324171635_575_on_co_20160413150827_941", using: :btree
  add_index "c29_20160324171635_575", ["company_id"], name: "index_c29_20160324171635_575_on_company_id", using: :btree
  add_index "c29_20160324171635_575", ["name"], name: "index_c29_20160324171635_575_on_name", using: :btree

  create_table "c29_20160414184131", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
  end

  create_table "c29_20160414184203", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
  end

  add_index "c29_20160414184203", ["company_id"], name: "index_c29_20160414184203_on_company_id", using: :btree
  add_index "c29_20160414184203", ["name"], name: "index_c29_20160414184203_on_name", using: :btree

  create_table "c29_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c29_companies", ["address"], name: "index_c29_companies_on_address", using: :btree
  add_index "c29_companies", ["fax"], name: "index_c29_companies_on_fax", using: :btree
  add_index "c29_companies", ["influx"], name: "index_c29_companies_on_influx", using: :btree
  add_index "c29_companies", ["mail"], name: "index_c29_companies_on_mail", using: :btree
  add_index "c29_companies", ["name"], name: "index_c29_companies_on_name", using: :btree
  add_index "c29_companies", ["pref"], name: "index_c29_companies_on_pref", using: :btree
  add_index "c29_companies", ["status"], name: "index_c29_companies_on_status", using: :btree
  add_index "c29_companies", ["target"], name: "index_c29_companies_on_target", using: :btree
  add_index "c29_companies", ["tel"], name: "index_c29_companies_on_tel", using: :btree
  add_index "c29_companies", ["url"], name: "index_c29_companies_on_url", using: :btree
  add_index "c29_companies", ["zip"], name: "index_c29_companies_on_zip", using: :btree

  create_table "c2_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151126184116_33385", default: "", null: false
    t.text     "co_20151126184116_96648", default: "", null: false
    t.text     "co_20151126184116_57458", default: "", null: false
    t.text     "co_20151126190011_57479", default: "", null: false
    t.text     "co_20151201120352_53180", default: "", null: false
    t.text     "co_20151207184657_87935", default: "", null: false
    t.text     "co_20151207184657_674",   default: "", null: false
  end

  add_index "c2_companies", ["co_20151126184116_33385"], name: "index_c2_companies_on_co_20151126184116_33385", using: :btree
  add_index "c2_companies", ["co_20151126184116_57458"], name: "index_c2_companies_on_co_20151126184116_57458", using: :btree
  add_index "c2_companies", ["co_20151126184116_96648"], name: "index_c2_companies_on_co_20151126184116_96648", using: :btree
  add_index "c2_companies", ["co_20151126190011_57479"], name: "index_c2_companies_on_co_20151126190011_57479", using: :btree
  add_index "c2_companies", ["co_20151201120352_53180"], name: "index_c2_companies_on_co_20151201120352_53180", using: :btree
  add_index "c2_companies", ["co_20151207184657_674"], name: "index_c2_companies_on_co_20151207184657_674", using: :btree
  add_index "c2_companies", ["co_20151207184657_87935"], name: "index_c2_companies_on_co_20151207184657_87935", using: :btree
  add_index "c2_companies", ["name"], name: "index_c2_companies_on_name", using: :btree

  create_table "c2_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c2_people", ["name"], name: "index_c2_people_on_name", using: :btree

  create_table "c30_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c30_companies", ["address"], name: "index_c30_companies_on_address", using: :btree
  add_index "c30_companies", ["fax"], name: "index_c30_companies_on_fax", using: :btree
  add_index "c30_companies", ["influx"], name: "index_c30_companies_on_influx", using: :btree
  add_index "c30_companies", ["mail"], name: "index_c30_companies_on_mail", using: :btree
  add_index "c30_companies", ["name"], name: "index_c30_companies_on_name", using: :btree
  add_index "c30_companies", ["pref"], name: "index_c30_companies_on_pref", using: :btree
  add_index "c30_companies", ["status"], name: "index_c30_companies_on_status", using: :btree
  add_index "c30_companies", ["target"], name: "index_c30_companies_on_target", using: :btree
  add_index "c30_companies", ["tel"], name: "index_c30_companies_on_tel", using: :btree
  add_index "c30_companies", ["url"], name: "index_c30_companies_on_url", using: :btree
  add_index "c30_companies", ["zip"], name: "index_c30_companies_on_zip", using: :btree

  create_table "c31_20160322121003_45205", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160329131337_455"
    t.string   "co_20160329131337_87"
    t.float    "co_20160329143810_362"
    t.datetime "co_20160329143810_893"
    t.integer  "co_20160329143810_614"
    t.string   "co_20160401164125_966"
    t.string   "co_20160401182346_263"
    t.text     "co_20160322181120_881"
    t.integer  "co_20160517171521_451"
    t.string   "co_20160517171521_728"
  end

  add_index "c31_20160322121003_45205", ["co_20160322181120_881"], name: "index_c31_20160322121003_45205_on_co_20160322181120_881", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160329131337_455"], name: "index_c31_20160322121003_45205_on_co_20160329131337_455", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160329131337_87"], name: "index_c31_20160322121003_45205_on_co_20160329131337_87", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160329143810_362"], name: "index_c31_20160322121003_45205_on_co_20160329143810_362", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160329143810_614"], name: "index_c31_20160322121003_45205_on_co_20160329143810_614", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160329143810_893"], name: "index_c31_20160322121003_45205_on_co_20160329143810_893", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160401164125_966"], name: "index_c31_20160322121003_45205_on_co_20160401164125_966", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160401182346_263"], name: "index_c31_20160322121003_45205_on_co_20160401182346_263", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160517171521_451"], name: "index_c31_20160322121003_45205_on_co_20160517171521_451", using: :btree
  add_index "c31_20160322121003_45205", ["co_20160517171521_728"], name: "index_c31_20160322121003_45205_on_co_20160517171521_728", using: :btree
  add_index "c31_20160322121003_45205", ["company_id"], name: "index_c31_20160322121003_45205_on_company_id", using: :btree
  add_index "c31_20160322121003_45205", ["name"], name: "index_c31_20160322121003_45205_on_name", using: :btree

  create_table "c31_20160324171635_575", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.integer  "company_id"
    t.string   "co_20160411153558_70"
  end

  add_index "c31_20160324171635_575", ["co_20160411153558_70"], name: "index_c31_20160324171635_575_on_co_20160411153558_70", using: :btree
  add_index "c31_20160324171635_575", ["company_id"], name: "index_c31_20160324171635_575_on_company_id", using: :btree
  add_index "c31_20160324171635_575", ["name"], name: "index_c31_20160324171635_575_on_name", using: :btree

  create_table "c31_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c31_companies", ["address"], name: "index_c31_companies_on_address", using: :btree
  add_index "c31_companies", ["fax"], name: "index_c31_companies_on_fax", using: :btree
  add_index "c31_companies", ["influx"], name: "index_c31_companies_on_influx", using: :btree
  add_index "c31_companies", ["mail"], name: "index_c31_companies_on_mail", using: :btree
  add_index "c31_companies", ["name"], name: "index_c31_companies_on_name", using: :btree
  add_index "c31_companies", ["pref"], name: "index_c31_companies_on_pref", using: :btree
  add_index "c31_companies", ["status"], name: "index_c31_companies_on_status", using: :btree
  add_index "c31_companies", ["target"], name: "index_c31_companies_on_target", using: :btree
  add_index "c31_companies", ["tel"], name: "index_c31_companies_on_tel", using: :btree
  add_index "c31_companies", ["url"], name: "index_c31_companies_on_url", using: :btree
  add_index "c31_companies", ["zip"], name: "index_c31_companies_on_zip", using: :btree

  create_table "c32_20160414182217", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
  end

  create_table "c32_companies", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
    t.string   "co_20160421084418_499"
    t.string   "co_20160421084418_525"
    t.string   "co_20160421084418_692"
    t.string   "co_20160421084418_311"
    t.string   "co_20160421084418_422"
    t.string   "co_20160421084418_634"
    t.string   "co_20160421084418_214"
    t.string   "co_20160421084418_199"
    t.string   "co_20160421084418_493"
    t.integer  "co_20160421085318_571"
    t.integer  "co_20160421085318_386"
    t.integer  "co_20160421090229_753"
    t.integer  "co_20160421090229_811"
  end

  add_index "c32_companies", ["address"], name: "index_c32_companies_on_address", using: :btree
  add_index "c32_companies", ["co_20160421084418_199"], name: "index_c32_companies_on_co_20160421084418_199", using: :btree
  add_index "c32_companies", ["co_20160421084418_214"], name: "index_c32_companies_on_co_20160421084418_214", using: :btree
  add_index "c32_companies", ["co_20160421084418_311"], name: "index_c32_companies_on_co_20160421084418_311", using: :btree
  add_index "c32_companies", ["co_20160421084418_422"], name: "index_c32_companies_on_co_20160421084418_422", using: :btree
  add_index "c32_companies", ["co_20160421084418_493"], name: "index_c32_companies_on_co_20160421084418_493", using: :btree
  add_index "c32_companies", ["co_20160421084418_499"], name: "index_c32_companies_on_co_20160421084418_499", using: :btree
  add_index "c32_companies", ["co_20160421084418_525"], name: "index_c32_companies_on_co_20160421084418_525", using: :btree
  add_index "c32_companies", ["co_20160421084418_634"], name: "index_c32_companies_on_co_20160421084418_634", using: :btree
  add_index "c32_companies", ["co_20160421084418_692"], name: "index_c32_companies_on_co_20160421084418_692", using: :btree
  add_index "c32_companies", ["co_20160421085318_386"], name: "index_c32_companies_on_co_20160421085318_386", using: :btree
  add_index "c32_companies", ["co_20160421085318_571"], name: "index_c32_companies_on_co_20160421085318_571", using: :btree
  add_index "c32_companies", ["co_20160421090229_753"], name: "index_c32_companies_on_co_20160421090229_753", using: :btree
  add_index "c32_companies", ["co_20160421090229_811"], name: "index_c32_companies_on_co_20160421090229_811", using: :btree
  add_index "c32_companies", ["fax"], name: "index_c32_companies_on_fax", using: :btree
  add_index "c32_companies", ["influx"], name: "index_c32_companies_on_influx", using: :btree
  add_index "c32_companies", ["mail"], name: "index_c32_companies_on_mail", using: :btree
  add_index "c32_companies", ["name"], name: "index_c32_companies_on_name", using: :btree
  add_index "c32_companies", ["pref"], name: "index_c32_companies_on_pref", using: :btree
  add_index "c32_companies", ["status"], name: "index_c32_companies_on_status", using: :btree
  add_index "c32_companies", ["target"], name: "index_c32_companies_on_target", using: :btree
  add_index "c32_companies", ["tel"], name: "index_c32_companies_on_tel", using: :btree
  add_index "c32_companies", ["url"], name: "index_c32_companies_on_url", using: :btree
  add_index "c32_companies", ["zip"], name: "index_c32_companies_on_zip", using: :btree

  create_table "c33_companies", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "soft_destroyed_at"
    t.string   "name"
    t.string   "pref"
    t.string   "tel"
    t.string   "fax"
    t.string   "zip"
    t.string   "address"
    t.string   "mail"
    t.string   "url"
    t.string   "status"
    t.string   "target"
    t.string   "influx"
  end

  add_index "c33_companies", ["address"], name: "index_c33_companies_on_address", using: :btree
  add_index "c33_companies", ["fax"], name: "index_c33_companies_on_fax", using: :btree
  add_index "c33_companies", ["influx"], name: "index_c33_companies_on_influx", using: :btree
  add_index "c33_companies", ["mail"], name: "index_c33_companies_on_mail", using: :btree
  add_index "c33_companies", ["name"], name: "index_c33_companies_on_name", using: :btree
  add_index "c33_companies", ["pref"], name: "index_c33_companies_on_pref", using: :btree
  add_index "c33_companies", ["status"], name: "index_c33_companies_on_status", using: :btree
  add_index "c33_companies", ["target"], name: "index_c33_companies_on_target", using: :btree
  add_index "c33_companies", ["tel"], name: "index_c33_companies_on_tel", using: :btree
  add_index "c33_companies", ["url"], name: "index_c33_companies_on_url", using: :btree
  add_index "c33_companies", ["zip"], name: "index_c33_companies_on_zip", using: :btree

  create_table "c3_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151204154036_63020", default: "", null: false
    t.text     "co_20151204154036_16968", default: "", null: false
    t.text     "co_20151204154036_72273", default: "", null: false
    t.text     "co_20151204154036_96451", default: "", null: false
    t.text     "co_20151204154036_23353", default: "", null: false
    t.text     "co_20151204154036_53098", default: "", null: false
    t.text     "co_20151204154036_73574", default: "", null: false
    t.text     "co_20151204154036_85384", default: "", null: false
    t.text     "co_20151207165251_50159", default: "", null: false
    t.text     "co_20151210165948_28656", default: "", null: false
    t.text     "co_20151210165948_47855", default: "", null: false
    t.text     "co_20151210165948_31073", default: "", null: false
    t.text     "co_20151210165948_84992", default: "", null: false
    t.text     "co_20151210165948_99200", default: "", null: false
    t.text     "co_20151210174207_23246", default: "", null: false
    t.text     "co_20151224181458_69764", default: "", null: false
  end

  add_index "c3_companies", ["co_20151204154036_16968"], name: "index_c3_companies_on_co_20151204154036_16968", using: :btree
  add_index "c3_companies", ["co_20151204154036_23353"], name: "index_c3_companies_on_co_20151204154036_23353", using: :btree
  add_index "c3_companies", ["co_20151204154036_53098"], name: "index_c3_companies_on_co_20151204154036_53098", using: :btree
  add_index "c3_companies", ["co_20151204154036_63020"], name: "index_c3_companies_on_co_20151204154036_63020", using: :btree
  add_index "c3_companies", ["co_20151204154036_72273"], name: "index_c3_companies_on_co_20151204154036_72273", using: :btree
  add_index "c3_companies", ["co_20151204154036_73574"], name: "index_c3_companies_on_co_20151204154036_73574", using: :btree
  add_index "c3_companies", ["co_20151204154036_85384"], name: "index_c3_companies_on_co_20151204154036_85384", using: :btree
  add_index "c3_companies", ["co_20151204154036_96451"], name: "index_c3_companies_on_co_20151204154036_96451", using: :btree
  add_index "c3_companies", ["co_20151207165251_50159"], name: "index_c3_companies_on_co_20151207165251_50159", using: :btree
  add_index "c3_companies", ["co_20151210165948_28656"], name: "index_c3_companies_on_co_20151210165948_28656", using: :btree
  add_index "c3_companies", ["co_20151210165948_31073"], name: "index_c3_companies_on_co_20151210165948_31073", using: :btree
  add_index "c3_companies", ["co_20151210165948_47855"], name: "index_c3_companies_on_co_20151210165948_47855", using: :btree
  add_index "c3_companies", ["co_20151210165948_84992"], name: "index_c3_companies_on_co_20151210165948_84992", using: :btree
  add_index "c3_companies", ["co_20151210165948_99200"], name: "index_c3_companies_on_co_20151210165948_99200", using: :btree
  add_index "c3_companies", ["co_20151210174207_23246"], name: "index_c3_companies_on_co_20151210174207_23246", using: :btree
  add_index "c3_companies", ["co_20151224181458_69764"], name: "index_c3_companies_on_co_20151224181458_69764", using: :btree
  add_index "c3_companies", ["name"], name: "index_c3_companies_on_name", using: :btree

  create_table "c3_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c3_people", ["name"], name: "index_c3_people_on_name", using: :btree

  create_table "c4_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151210174207_23246", default: "", null: false
    t.text     "co_20151204154036_72273", default: "", null: false
    t.text     "co_20151204154036_63020", default: "", null: false
    t.text     "co_20151204154036_16968", default: "", null: false
    t.text     "co_20151204154036_96451", default: "", null: false
    t.text     "co_20151204154036_23353", default: "", null: false
    t.text     "co_20151204154036_53098", default: "", null: false
    t.text     "co_20151204154036_73574", default: "", null: false
    t.text     "co_20151204154036_85384", default: "", null: false
    t.text     "co_20151207165251_50159", default: "", null: false
    t.text     "co_20151210165948_28656", default: "", null: false
    t.text     "co_20151210165948_47855", default: "", null: false
    t.text     "co_20151210165948_31073", default: "", null: false
    t.text     "co_20151210165948_84992", default: "", null: false
    t.text     "co_20151210165948_99200", default: "", null: false
  end

  add_index "c4_companies", ["co_20151204154036_16968"], name: "index_c4_companies_on_co_20151204154036_16968", using: :btree
  add_index "c4_companies", ["co_20151204154036_23353"], name: "index_c4_companies_on_co_20151204154036_23353", using: :btree
  add_index "c4_companies", ["co_20151204154036_53098"], name: "index_c4_companies_on_co_20151204154036_53098", using: :btree
  add_index "c4_companies", ["co_20151204154036_63020"], name: "index_c4_companies_on_co_20151204154036_63020", using: :btree
  add_index "c4_companies", ["co_20151204154036_72273"], name: "index_c4_companies_on_co_20151204154036_72273", using: :btree
  add_index "c4_companies", ["co_20151204154036_73574"], name: "index_c4_companies_on_co_20151204154036_73574", using: :btree
  add_index "c4_companies", ["co_20151204154036_85384"], name: "index_c4_companies_on_co_20151204154036_85384", using: :btree
  add_index "c4_companies", ["co_20151204154036_96451"], name: "index_c4_companies_on_co_20151204154036_96451", using: :btree
  add_index "c4_companies", ["co_20151207165251_50159"], name: "index_c4_companies_on_co_20151207165251_50159", using: :btree
  add_index "c4_companies", ["co_20151210165948_28656"], name: "index_c4_companies_on_co_20151210165948_28656", using: :btree
  add_index "c4_companies", ["co_20151210165948_31073"], name: "index_c4_companies_on_co_20151210165948_31073", using: :btree
  add_index "c4_companies", ["co_20151210165948_47855"], name: "index_c4_companies_on_co_20151210165948_47855", using: :btree
  add_index "c4_companies", ["co_20151210165948_84992"], name: "index_c4_companies_on_co_20151210165948_84992", using: :btree
  add_index "c4_companies", ["co_20151210165948_99200"], name: "index_c4_companies_on_co_20151210165948_99200", using: :btree
  add_index "c4_companies", ["co_20151210174207_23246"], name: "index_c4_companies_on_co_20151210174207_23246", using: :btree
  add_index "c4_companies", ["name"], name: "index_c4_companies_on_name", using: :btree

  create_table "c4_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c4_people", ["name"], name: "index_c4_people_on_name", using: :btree

  create_table "c5_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151210174207_23246", default: "", null: false
    t.text     "co_20151204154036_72273", default: "", null: false
    t.text     "co_20151204154036_63020", default: "", null: false
    t.text     "co_20151204154036_16968", default: "", null: false
    t.text     "co_20151204154036_96451", default: "", null: false
    t.text     "co_20151204154036_23353", default: "", null: false
    t.text     "co_20151204154036_53098", default: "", null: false
    t.text     "co_20151204154036_73574", default: "", null: false
    t.text     "co_20151204154036_85384", default: "", null: false
    t.text     "co_20151207165251_50159", default: "", null: false
    t.text     "co_20151210165948_28656", default: "", null: false
    t.text     "co_20151210165948_47855", default: "", null: false
    t.text     "co_20151210165948_31073", default: "", null: false
    t.text     "co_20151210165948_84992", default: "", null: false
    t.text     "co_20151210165948_99200", default: "", null: false
  end

  add_index "c5_companies", ["co_20151204154036_16968"], name: "index_c5_companies_on_co_20151204154036_16968", using: :btree
  add_index "c5_companies", ["co_20151204154036_23353"], name: "index_c5_companies_on_co_20151204154036_23353", using: :btree
  add_index "c5_companies", ["co_20151204154036_53098"], name: "index_c5_companies_on_co_20151204154036_53098", using: :btree
  add_index "c5_companies", ["co_20151204154036_63020"], name: "index_c5_companies_on_co_20151204154036_63020", using: :btree
  add_index "c5_companies", ["co_20151204154036_72273"], name: "index_c5_companies_on_co_20151204154036_72273", using: :btree
  add_index "c5_companies", ["co_20151204154036_73574"], name: "index_c5_companies_on_co_20151204154036_73574", using: :btree
  add_index "c5_companies", ["co_20151204154036_85384"], name: "index_c5_companies_on_co_20151204154036_85384", using: :btree
  add_index "c5_companies", ["co_20151204154036_96451"], name: "index_c5_companies_on_co_20151204154036_96451", using: :btree
  add_index "c5_companies", ["co_20151207165251_50159"], name: "index_c5_companies_on_co_20151207165251_50159", using: :btree
  add_index "c5_companies", ["co_20151210165948_28656"], name: "index_c5_companies_on_co_20151210165948_28656", using: :btree
  add_index "c5_companies", ["co_20151210165948_31073"], name: "index_c5_companies_on_co_20151210165948_31073", using: :btree
  add_index "c5_companies", ["co_20151210165948_47855"], name: "index_c5_companies_on_co_20151210165948_47855", using: :btree
  add_index "c5_companies", ["co_20151210165948_84992"], name: "index_c5_companies_on_co_20151210165948_84992", using: :btree
  add_index "c5_companies", ["co_20151210165948_99200"], name: "index_c5_companies_on_co_20151210165948_99200", using: :btree
  add_index "c5_companies", ["co_20151210174207_23246"], name: "index_c5_companies_on_co_20151210174207_23246", using: :btree
  add_index "c5_companies", ["name"], name: "index_c5_companies_on_name", using: :btree

  create_table "c5_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c5_people", ["name"], name: "index_c5_people_on_name", using: :btree

  create_table "c6_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151224195946_93323", default: "", null: false
    t.text     "co_20151224200155_13527", default: "", null: false
    t.text     "co_20151224200155_34132", default: "", null: false
    t.text     "co_20151224200155_94227", default: "", null: false
    t.text     "co_20151224200155_87029", default: "", null: false
    t.text     "co_20151224200155_88689", default: "", null: false
    t.text     "co_20151224200155_54596", default: "", null: false
    t.text     "co_20151224200155_33996", default: "", null: false
    t.text     "co_20151224200155_49027", default: "", null: false
    t.text     "co_20151224201321_77856", default: "", null: false
  end

  add_index "c6_companies", ["co_20151224195946_93323"], name: "index_c6_companies_on_co_20151224195946_93323", using: :btree
  add_index "c6_companies", ["co_20151224200155_13527"], name: "index_c6_companies_on_co_20151224200155_13527", using: :btree
  add_index "c6_companies", ["co_20151224200155_33996"], name: "index_c6_companies_on_co_20151224200155_33996", using: :btree
  add_index "c6_companies", ["co_20151224200155_34132"], name: "index_c6_companies_on_co_20151224200155_34132", using: :btree
  add_index "c6_companies", ["co_20151224200155_49027"], name: "index_c6_companies_on_co_20151224200155_49027", using: :btree
  add_index "c6_companies", ["co_20151224200155_54596"], name: "index_c6_companies_on_co_20151224200155_54596", using: :btree
  add_index "c6_companies", ["co_20151224200155_87029"], name: "index_c6_companies_on_co_20151224200155_87029", using: :btree
  add_index "c6_companies", ["co_20151224200155_88689"], name: "index_c6_companies_on_co_20151224200155_88689", using: :btree
  add_index "c6_companies", ["co_20151224200155_94227"], name: "index_c6_companies_on_co_20151224200155_94227", using: :btree
  add_index "c6_companies", ["co_20151224201321_77856"], name: "index_c6_companies_on_co_20151224201321_77856", using: :btree
  add_index "c6_companies", ["name"], name: "index_c6_companies_on_name", using: :btree

  create_table "c6_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c6_people", ["name"], name: "index_c6_people_on_name", using: :btree

  create_table "c7_companies", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151225163928_74804", default: "", null: false
    t.text     "co_20151225163928_17737", default: "", null: false
    t.text     "co_20151225163928_64328", default: "", null: false
    t.text     "co_20151225163928_77386", default: "", null: false
    t.text     "co_20151225163928_71061", default: "", null: false
    t.text     "co_20151225163928_13156", default: "", null: false
    t.text     "co_20151225163928_35669", default: "", null: false
    t.text     "co_20151225163928_51066", default: "", null: false
    t.text     "co_20151225163928_75316", default: "", null: false
    t.text     "co_20151225163928_41514", default: "", null: false
    t.text     "co_20151225163928_5840",  default: "", null: false
    t.text     "co_20151225163928_64029", default: "", null: false
    t.text     "co_20151225163928_36354", default: "", null: false
    t.text     "co_20151225163928_75089", default: "", null: false
    t.text     "co_20151225163928_18218", default: "", null: false
    t.text     "co_20151225163928_6457",  default: "", null: false
    t.text     "co_20151225163928_9439",  default: "", null: false
    t.text     "co_20151225163928_40831", default: "", null: false
    t.text     "co_20151225163928_40939", default: "", null: false
    t.text     "co_20151225164530_33323", default: "", null: false
    t.text     "co_20151225170838_57969", default: "", null: false
    t.text     "co_20151225170838_86398", default: "", null: false
    t.text     "co_20151225170838_59411", default: "", null: false
  end

  add_index "c7_companies", ["co_20151225163928_13156"], name: "index_c7_companies_on_co_20151225163928_13156", using: :btree
  add_index "c7_companies", ["co_20151225163928_17737"], name: "index_c7_companies_on_co_20151225163928_17737", using: :btree
  add_index "c7_companies", ["co_20151225163928_18218"], name: "index_c7_companies_on_co_20151225163928_18218", using: :btree
  add_index "c7_companies", ["co_20151225163928_35669"], name: "index_c7_companies_on_co_20151225163928_35669", using: :btree
  add_index "c7_companies", ["co_20151225163928_36354"], name: "index_c7_companies_on_co_20151225163928_36354", using: :btree
  add_index "c7_companies", ["co_20151225163928_40831"], name: "index_c7_companies_on_co_20151225163928_40831", using: :btree
  add_index "c7_companies", ["co_20151225163928_40939"], name: "index_c7_companies_on_co_20151225163928_40939", using: :btree
  add_index "c7_companies", ["co_20151225163928_41514"], name: "index_c7_companies_on_co_20151225163928_41514", using: :btree
  add_index "c7_companies", ["co_20151225163928_51066"], name: "index_c7_companies_on_co_20151225163928_51066", using: :btree
  add_index "c7_companies", ["co_20151225163928_5840"], name: "index_c7_companies_on_co_20151225163928_5840", using: :btree
  add_index "c7_companies", ["co_20151225163928_64029"], name: "index_c7_companies_on_co_20151225163928_64029", using: :btree
  add_index "c7_companies", ["co_20151225163928_64328"], name: "index_c7_companies_on_co_20151225163928_64328", using: :btree
  add_index "c7_companies", ["co_20151225163928_6457"], name: "index_c7_companies_on_co_20151225163928_6457", using: :btree
  add_index "c7_companies", ["co_20151225163928_71061"], name: "index_c7_companies_on_co_20151225163928_71061", using: :btree
  add_index "c7_companies", ["co_20151225163928_74804"], name: "index_c7_companies_on_co_20151225163928_74804", using: :btree
  add_index "c7_companies", ["co_20151225163928_75089"], name: "index_c7_companies_on_co_20151225163928_75089", using: :btree
  add_index "c7_companies", ["co_20151225163928_75316"], name: "index_c7_companies_on_co_20151225163928_75316", using: :btree
  add_index "c7_companies", ["co_20151225163928_77386"], name: "index_c7_companies_on_co_20151225163928_77386", using: :btree
  add_index "c7_companies", ["co_20151225163928_9439"], name: "index_c7_companies_on_co_20151225163928_9439", using: :btree
  add_index "c7_companies", ["co_20151225164530_33323"], name: "index_c7_companies_on_co_20151225164530_33323", using: :btree
  add_index "c7_companies", ["co_20151225170838_57969"], name: "index_c7_companies_on_co_20151225170838_57969", using: :btree
  add_index "c7_companies", ["co_20151225170838_59411"], name: "index_c7_companies_on_co_20151225170838_59411", using: :btree
  add_index "c7_companies", ["co_20151225170838_86398"], name: "index_c7_companies_on_co_20151225170838_86398", using: :btree
  add_index "c7_companies", ["name"], name: "index_c7_companies_on_name", using: :btree

  create_table "c7_people", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                    default: "", null: false
    t.text     "co_20151225184610_82649", default: "", null: false
    t.text     "co_20151225184610_24757", default: "", null: false
    t.text     "co_20151225184610_38856", default: "", null: false
    t.text     "co_20151225184610_45139", default: "", null: false
    t.text     "co_20151225184610_38284", default: "", null: false
    t.text     "co_20151225184610_48782", default: "", null: false
    t.text     "co_20151225184610_89963", default: "", null: false
    t.text     "co_20151225184610_6044",  default: "", null: false
    t.text     "co_20151225184610_70938", default: "", null: false
    t.text     "co_20151225184610_37950", default: "", null: false
    t.text     "co_20151225184723_43109", default: "", null: false
  end

  add_index "c7_people", ["co_20151225184610_24757"], name: "index_c7_people_on_co_20151225184610_24757", using: :btree
  add_index "c7_people", ["co_20151225184610_37950"], name: "index_c7_people_on_co_20151225184610_37950", using: :btree
  add_index "c7_people", ["co_20151225184610_38284"], name: "index_c7_people_on_co_20151225184610_38284", using: :btree
  add_index "c7_people", ["co_20151225184610_38856"], name: "index_c7_people_on_co_20151225184610_38856", using: :btree
  add_index "c7_people", ["co_20151225184610_45139"], name: "index_c7_people_on_co_20151225184610_45139", using: :btree
  add_index "c7_people", ["co_20151225184610_48782"], name: "index_c7_people_on_co_20151225184610_48782", using: :btree
  add_index "c7_people", ["co_20151225184610_6044"], name: "index_c7_people_on_co_20151225184610_6044", using: :btree
  add_index "c7_people", ["co_20151225184610_70938"], name: "index_c7_people_on_co_20151225184610_70938", using: :btree
  add_index "c7_people", ["co_20151225184610_82649"], name: "index_c7_people_on_co_20151225184610_82649", using: :btree
  add_index "c7_people", ["co_20151225184610_89963"], name: "index_c7_people_on_co_20151225184610_89963", using: :btree
  add_index "c7_people", ["co_20151225184723_43109"], name: "index_c7_people_on_co_20151225184723_43109", using: :btree
  add_index "c7_people", ["name"], name: "index_c7_people_on_name", using: :btree

  create_table "c8_companies", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c8_companies", ["name"], name: "index_c8_companies_on_name", using: :btree

  create_table "c8_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c8_people", ["name"], name: "index_c8_people_on_name", using: :btree

  create_table "c9_companies", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c9_companies", ["name"], name: "index_c9_companies_on_name", using: :btree

  create_table "c9_people", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",              default: "", null: false
  end

  add_index "c9_people", ["name"], name: "index_c9_people_on_name", using: :btree

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

  add_index "clients", ["email"], name: "index_clients_on_email", unique: true, using: :btree
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

  create_table "imports", force: :cascade do |t|
    t.text     "matching_params"
    t.integer  "success_num"
    t.integer  "unmatch_num"
    t.integer  "overlap_num"
    t.integer  "error_num"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "error_message"
    t.text     "errors_ids"
    t.datetime "soft_destroyed_at"
    t.datetime "uploaded_at"
    t.datetime "queued_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.datetime "rescued_at"
    t.integer  "csvfile_id"
  end

  add_index "imports", ["csvfile_id"], name: "index_imports_on_csvfile_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

end
