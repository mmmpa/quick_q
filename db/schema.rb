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

ActiveRecord::Schema.define(version: 20151022004426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "qa_answer_options", force: :cascade do |t|
    t.string  "text",                    null: false
    t.integer "index",       default: 0, null: false
    t.integer "question_id"
  end

  add_index "qa_answer_options", ["question_id"], name: "index_qa_answer_options_on_question_id", using: :btree

  create_table "qa_correct_answers", force: :cascade do |t|
    t.integer "index",            default: 0, null: false
    t.integer "question_id"
    t.integer "answer_option_id"
  end

  add_index "qa_correct_answers", ["answer_option_id"], name: "index_qa_correct_answers_on_answer_option_id", using: :btree
  add_index "qa_correct_answers", ["question_id"], name: "index_qa_correct_answers_on_question_id", using: :btree

  create_table "qa_explanations", force: :cascade do |t|
    t.text    "text"
    t.integer "question_id"
  end

  add_index "qa_explanations", ["question_id"], name: "index_qa_explanations_on_question_id", using: :btree

  create_table "qa_questions", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "text",                   null: false
    t.integer  "way",        default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "qa_questions", ["name"], name: "index_qa_questions_on_name", unique: true, using: :btree

end
