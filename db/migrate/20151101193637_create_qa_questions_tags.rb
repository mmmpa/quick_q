class CreateQaQuestionsTags < ActiveRecord::Migration
  def change
    create_table :qa_questions_tags do |t|
    end

    add_reference :qa_questions_tags, :question, index: true
    add_reference :qa_questions_tags, :tag, index: true
    add_index :qa_questions_tags, [:question_id, :tag_id], unique: true
  end
end
