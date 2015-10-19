class CreateQaCorrectAnswers < ActiveRecord::Migration
  def change
    create_table :qa_correct_answers do |t|
      t.string :text, null:false
      t.integer :index, null: false, default: 0
    end

    add_reference :qa_correct_answers, :qa_question, index: true
  end
end
