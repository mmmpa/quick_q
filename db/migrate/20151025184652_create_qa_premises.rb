class CreateQaPremises < ActiveRecord::Migration
  def change
    create_table :qa_premises do |t|
      t.string :name, null: false
      t.text :text, null: false
    end

    add_index :qa_premises, :name, unique: true
  end
end
