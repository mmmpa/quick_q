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

ActiveRecord::Schema.define(version: 20151101053348) do

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

  create_table "qa_pals", force: :cascade do |t|
    t.integer "question_id"
    t.integer "premise_id"
  end

  add_index "qa_pals", ["premise_id"], name: "index_qa_pals_on_premise_id", using: :btree
  add_index "qa_pals", ["question_id"], name: "index_qa_pals_on_question_id", using: :btree

  create_table "qa_premises", force: :cascade do |t|
    t.string "name", null: false
    t.text   "text", null: false
  end

  add_index "qa_premises", ["name"], name: "index_qa_premises_on_name", unique: true, using: :btree

  create_table "qa_questions", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "text",                   null: false
    t.integer  "way",        default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "qa_questions", ["name"], name: "index_qa_questions_on_name", unique: true, using: :btree

  create_table "qa_quotes", force: :cascade do |t|
    t.integer "question_id"
    t.integer "source_link_id"
  end

  add_index "qa_quotes", ["question_id", "source_link_id"], name: "index_qa_quotes_on_question_id_and_source_link_id", unique: true, using: :btree
  add_index "qa_quotes", ["question_id"], name: "index_qa_quotes_on_question_id", using: :btree
  add_index "qa_quotes", ["source_link_id"], name: "index_qa_quotes_on_source_link_id", using: :btree

  create_table "qa_source_links", force: :cascade do |t|
    t.string "name", null: false
    t.string "url",  null: false
  end

  add_index "qa_source_links", ["url"], name: "index_qa_source_links_on_url", unique: true, using: :btree

  create_table "selection_selected_questions", force: :cascade do |t|
    t.integer "selection_id"
    t.integer "question_id"
  end

  add_index "selection_selected_questions", ["question_id"], name: "index_selection_selected_questions_on_question_id", using: :btree
  add_index "selection_selected_questions", ["selection_id", "question_id"], name: "selection_selected_questions_s_q", unique: true, using: :btree
  add_index "selection_selected_questions", ["selection_id"], name: "index_selection_selected_questions_on_selection_id", using: :btree

  create_table "selection_selections", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "choice_type", null: false
    t.integer  "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workbook_books", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "eval_type",  null: false
    t.integer  "passing",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workbook_questions", force: :cascade do |t|
    t.integer "score",       default: 1, null: false
    t.integer "book_id"
    t.integer "question_id"
  end

  add_index "workbook_questions", ["book_id"], name: "index_workbook_questions_on_book_id", using: :btree
  add_index "workbook_questions", ["question_id"], name: "index_workbook_questions_on_question_id", using: :btree

end
