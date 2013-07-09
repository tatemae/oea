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

ActiveRecord::Schema.define(version: 20130709174040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessment_results", force: true do |t|
    t.integer  "assessment_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_results", ["assessment_id"], name: "index_assessment_results_on_assessment_id", using: :btree
  add_index "assessment_results", ["user_id"], name: "index_assessment_results_on_user_id", using: :btree

  create_table "assessments", force: true do |t|
    t.string   "xml",         limit: 1048576
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
  end

  add_index "assessments", ["identifier"], name: "index_assessments_on_identifier", using: :btree

  create_table "item_results", force: true do |t|
    t.string   "identifier"
    t.string   "sequence_index"
    t.datetime "datestamp"
    t.string   "session_status"
    t.string   "item_variable",        limit: 1048576
    t.string   "candidate_comment"
    t.datetime "rendered_datestamp"
    t.string   "referer"
    t.string   "ip_address"
    t.integer  "item_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assessment_result_id"
  end

  add_index "item_results", ["assessment_result_id"], name: "index_item_results_on_assessment_result_id", using: :btree
  add_index "item_results", ["item_id"], name: "index_item_results_on_item_id", using: :btree
  add_index "item_results", ["user_id"], name: "index_item_results_on_user_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "identifier"
    t.string   "xml",         limit: 1048576
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.integer  "section_id"
  end

  add_index "items", ["identifier"], name: "index_items_on_identifier", using: :btree

  create_table "sections", force: true do |t|
    t.string   "xml",           limit: 1048576
    t.string   "identifier"
    t.integer  "assessment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["identifier"], name: "index_sections_on_identifier", using: :btree

  create_table "test_results", force: true do |t|
    t.integer  "assessment_result_id"
    t.integer  "identifier"
    t.datetime "datestamp"
    t.string   "item_variable",        limit: 1048576
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "test_results", ["assessment_result_id"], name: "index_test_results_on_assessment_result_id", using: :btree
  add_index "test_results", ["identifier"], name: "index_test_results_on_identifier", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
