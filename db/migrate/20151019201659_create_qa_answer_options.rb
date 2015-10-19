class CreateQaAnswerOptions < ActiveRecord::Migration
  def change
    create_table :qa_answer_options do |t|
      t.string :text, null:false
      t.integer :index, null: false, default: 0
    end

    add_reference :qa_answer_options, :qa_question, index: true
  end
end
