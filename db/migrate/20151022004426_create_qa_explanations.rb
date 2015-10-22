class CreateQaExplanations < ActiveRecord::Migration
  def change
    create_table :qa_explanations do |t|
      t.text :text
    end

    add_reference :qa_explanations, :question, index: true
  end
end
