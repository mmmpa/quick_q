class CreateQaPals < ActiveRecord::Migration
  def change
    create_table :qa_pals do |t|
    end

    add_reference :qa_pals, :question, index: true, unique: true
    add_reference :qa_pals, :premise, index: true
  end
end
