class CreateQaQuestions < ActiveRecord::Migration
  def change
    create_table :qa_questions do |t|
      t.string :name, null: false
      t.string :text, null: false
      t.integer :way, null: false, default: 0
      t.timestamps null: false
    end

    add_index :qa_questions, :name, unique: true
  end
end
