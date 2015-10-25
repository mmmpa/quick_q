class CreateQaPals < ActiveRecord::Migration
  def change
    create_table :qa_pals do |t|
    end

    add_reference :qa_pals, :question, index: true
    add_reference :qa_pals, :premise, index: true
    add_index :qa_pals, :question_id, unique: true
  end
end
