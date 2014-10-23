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

ActiveRecord::Schema.define(version: 20141023134908) do

  create_table "cities", force: true do |t|
    t.integer  "province_id"
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["province_id"], name: "index_cities_on_province_id"

  create_table "countries", force: true do |t|
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
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
    t.float    "download_kbps"
    t.float    "upload_kbps"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "isps", ["city_id"], name: "index_isps_on_city_id"
  add_index "isps", ["isp_company_id"], name: "index_isps_on_isp_company_id"

  create_table "provinces", force: true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["country_id"], name: "index_provinces_on_country_id"

  create_table "speed_test_results", force: true do |t|
    t.integer  "city_id"
    t.integer  "isp_company_id"
    t.datetime "date"
    t.float    "download_kbps"
    t.float    "upload_kbps"
    t.integer  "total_tests"
    t.float    "distance_miles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "speed_test_results", ["city_id"], name: "index_speed_test_results_on_city_id"
  add_index "speed_test_results", ["isp_company_id"], name: "index_speed_test_results_on_isp_company_id"

end
