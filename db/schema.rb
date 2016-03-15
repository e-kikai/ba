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

ActiveRecord::Schema.define(version: 20160307075017) do

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

  create_table "c16_companies", force: :cascade do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "soft_destroyed_at"
    t.text     "name",                  default: "", null: false
    t.text     "co_20160228033730_358", default: "", null: false
  end

  add_index "c16_companies", ["co_20160228033730_358"], name: "index_c16_companies_on_co_20160228033730_358", using: :btree
  add_index "c16_companies", ["name"], name: "index_c16_companies_on_name", using: :btree

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

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

end
