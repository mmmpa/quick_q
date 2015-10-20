class CreateQaCorrectAnswers < ActiveRecord::Migration
  def change
    create_table :qa_correct_answers do |t|
      t.integer :index, null: false, default: 0
    end

    add_reference :qa_correct_answers, :question, index: true
    add_reference :qa_correct_answers, :answer_option, index: true
  end
end
