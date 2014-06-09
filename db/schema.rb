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

ActiveRecord::Schema.define(version: 20140609205026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessment_outcomes", force: true do |t|
    t.integer  "assessment_id"
    t.integer  "outcome_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_outcomes", ["assessment_id", "outcome_id"], name: "index_assessment_outcomes_on_assessment_id_and_outcome_id", using: :btree
  add_index "assessment_outcomes", ["assessment_id"], name: "index_assessment_outcomes_on_assessment_id", using: :btree
  add_index "assessment_outcomes", ["outcome_id"], name: "index_assessment_outcomes_on_outcome_id", using: :btree

  create_table "assessment_results", force: true do |t|
    t.integer  "assessment_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "rendered_datestamp"
    t.string   "session_status"
    t.string   "referer"
    t.string   "ip_address"
    t.string   "eid"
    t.string   "src_url"
    t.string   "identifier"
    t.string   "keywords"
    t.string   "external_user_id"
  end

  add_index "assessment_results", ["assessment_id"], name: "index_assessment_results_on_assessment_id", using: :btree
  add_index "assessment_results", ["referer"], name: "index_assessment_results_on_referer", using: :btree
  add_index "assessment_results", ["user_id"], name: "index_assessment_results_on_user_id", using: :btree

  create_table "assessment_xmls", force: true do |t|
    t.string   "xml",           limit: 1048576
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assessment_id"
  end

  create_table "assessments", force: true do |t|
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.string   "src_url"
    t.datetime "published_at"
    t.integer  "recommended_height"
    t.string   "license"
    t.string   "keywords"
  end

  add_index "assessments", ["identifier", "user_id"], name: "index_assessments_on_identifier_and_user_id", using: :btree
  add_index "assessments", ["src_url", "user_id"], name: "index_assessments_on_src_url_and_user_id", using: :btree

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
    t.integer  "time_elapsed"
    t.integer  "confidence_level"
    t.string   "eid"
    t.string   "src_url"
    t.string   "external_user_id"
  end

  add_index "item_results", ["assessment_result_id"], name: "index_item_results_on_assessment_result_id", using: :btree
  add_index "item_results", ["item_id"], name: "index_item_results_on_item_id", using: :btree
  add_index "item_results", ["user_id"], name: "index_item_results_on_user_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "description",       limit: 32768
    t.integer  "section_id"
    t.string   "question_text",     limit: 32768
    t.string   "answers",           limit: 32768
    t.string   "feedback",          limit: 32768
    t.string   "item_feedback",     limit: 32768
    t.string   "correct_responses", limit: 32768
    t.string   "base_type"
    t.string   "keywords"
  end

  add_index "items", ["identifier", "section_id"], name: "index_items_on_identifier_and_section_id", using: :btree

  create_table "outcomes", force: true do |t|
    t.string   "name"
    t.string   "mc3_bank_id"
    t.string   "mc3_objective_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "identifier"
    t.integer  "assessment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["identifier"], name: "index_sections_on_identifier", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.string   "external_id"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
