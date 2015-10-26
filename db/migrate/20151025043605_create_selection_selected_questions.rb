class CreateSelectionSelectedQuestions < ActiveRecord::Migration
  def change
    create_table :selection_selected_questions do |t|
    end

    add_reference :selection_selected_questions, :selection, index: true
    add_reference :selection_selected_questions, :question, index: true
    add_index :selection_selected_questions, [:selection_id, :question_id], unique: true, name: :selection_selected_questions_s_q
  end
end
