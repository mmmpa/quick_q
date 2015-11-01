class CreateQaQuotes < ActiveRecord::Migration
  def change
    create_table :qa_quotes do |t|
    end

    add_reference :qa_quotes, :question, index: true
    add_reference :qa_quotes, :source_link, index: true
    add_index :qa_quotes, :question_id, unique: true
  end
end
