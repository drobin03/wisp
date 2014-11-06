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

ActiveRecord::Schema.define(version: 20141106175302) do

  create_table "cities", force: true do |t|
    t.integer  "province_id"
    t.string   "name"
    t.float    "longitude",   limit: 24
    t.float    "latitude",    limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["province_id"], name: "index_cities_on_province_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "user_name"
    t.text     "subject"
    t.text     "body"
    t.integer  "isp_company_id"
    t.integer  "city_id"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["city_id"], name: "index_conversations_on_city_id", using: :btree
  add_index "conversations", ["isp_company_id"], name: "index_conversations_on_isp_company_id", using: :btree
  add_index "conversations", ["province_id"], name: "index_conversations_on_province_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name"
    t.float    "longitude",  limit: 24
    t.float    "latitude",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "isp_companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "isps", force: true do |t|
    t.integer  "city_id"
    t.integer  "isp_company_id"
    t.float    "download_kbps",  limit: 24
    t.float    "upload_kbps",    limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cable_price",    limit: 24, default: 0.0
  end

  add_index "isps", ["city_id"], name: "index_isps_on_city_id", using: :btree
  add_index "isps", ["isp_company_id"], name: "index_isps_on_isp_company_id", using: :btree

  create_table "provinces", force: true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.float    "longitude",  limit: 24
    t.float    "latitude",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["country_id"], name: "index_provinces_on_country_id", using: :btree

  create_table "speed_test_results", force: true do |t|
    t.integer  "city_id"
    t.integer  "isp_company_id"
    t.datetime "date"
    t.float    "download_kbps",  limit: 24
    t.float    "upload_kbps",    limit: 24
    t.integer  "total_tests"
    t.float    "distance_miles", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "speed_test_results", ["city_id", "isp_company_id", "date"], name: "uniqueness_index", unique: true, using: :btree
  add_index "speed_test_results", ["city_id"], name: "index_speed_test_results_on_city_id", using: :btree
  add_index "speed_test_results", ["isp_company_id"], name: "index_speed_test_results_on_isp_company_id", using: :btree

end
