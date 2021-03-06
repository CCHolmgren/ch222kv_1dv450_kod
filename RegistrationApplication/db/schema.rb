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

ActiveRecord::Schema.define(version: 20150316102342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_applications", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "client_key"
    t.string   "client_secret"
    t.string   "url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "event_tags", primary_key: "tag_id", force: :cascade do |t|
    t.integer "event_id", null: false
  end

  add_index "event_tags", ["event_id"], name: "index_event_tags_on_event_id", using: :btree
  add_index "event_tags", ["tag_id"], name: "index_event_tags_on_tag_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "short_description"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  create_table "events_tags", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "tag_id"
  end

  add_index "events_tags", ["event_id"], name: "index_events_tags_on_event_id", using: :btree
  add_index "events_tags", ["tag_id"], name: "index_events_tags_on_tag_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "value"
    t.datetime "expiry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.boolean  "is_administrator"
    t.string   "email"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "remember_digest"
    t.string   "auth_token"
  end

end
