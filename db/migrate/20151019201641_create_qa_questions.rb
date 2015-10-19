class CreateQaQuestions < ActiveRecord::Migration
  def change
    create_table :qa_questions do |t|
      t.string :text, null:false
      t.integer :way, null: false, default: 0
      t.timestamps null: false
    end

  end
end
