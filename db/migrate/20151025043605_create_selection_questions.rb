class CreateSelectionQuestions < ActiveRecord::Migration
  def change
    create_table :selection_questions do |t|
    end

    add_reference :selection_questions, :selection, index: true
    add_reference :selection_questions, :question, index: true
  end
end
