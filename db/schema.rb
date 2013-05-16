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

ActiveRecord::Schema.define(version: 20130516184522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_results", force: true do |t|
    t.string   "identifier"
    t.string   "sequence_index"
    t.datetime "datestamp"
    t.string   "session_status"
    t.string   "item_variable"
    t.string   "candidate_comment"
    t.datetime "rendered_datestamp"
    t.string   "referer"
    t.string   "ip_address"
    t.integer  "item_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "external_id"
    t.string   "xml",         limit: 1048576
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["external_id"], name: "index_items_on_external_id", using: :btree

end
