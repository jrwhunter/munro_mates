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

ActiveRecord::Schema.define(version: 20140605124007) do

  create_table "ascents", force: true do |t|
    t.integer  "user_id"
    t.integer  "hill_id"
    t.date     "date"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "climbed"
  end

  add_index "ascents", ["hill_id"], name: "index_ascents_on_hill_id"
  add_index "ascents", ["user_id", "hill_id"], name: "index_ascents_on_user_id_and_hill_id", unique: true
  add_index "ascents", ["user_id"], name: "index_ascents_on_user_id"

  create_table "hills", force: true do |t|
    t.string   "number"
    t.string   "name"
    t.string   "other_info"
    t.string   "origin"
    t.string   "chapter"
    t.string   "height"
    t.string   "grid_ref"
    t.string   "map"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.string   "local_links"
    t.string   "km_5_links"
    t.string   "km_10_links"
    t.string   "km_20_links"
  end

  add_index "hills", ["number"], name: "index_hills_on_number", unique: true

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "club"
    t.boolean  "visible"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.boolean  "munros"
    t.boolean  "munro_tops"
    t.boolean  "corbetts"
    t.boolean  "grahams"
    t.string   "category"
    t.string   "selected"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
