class CreateWorkbookQuestions < ActiveRecord::Migration
  def change
    create_table :workbook_questions do |t|
      t.integer :score, null:false, default: 1
    end

    add_reference :workbook_questions, :book, index: true
    add_reference :workbook_questions, :question, index: true
  end
end
