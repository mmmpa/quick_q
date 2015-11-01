class CreateQaSourceLinks < ActiveRecord::Migration
  def change
    create_table :qa_source_links do |t|
      t.string :name, null: false
      t.string :display, null: false
      t.string :url, null: false
    end

    add_index :qa_source_links, :name, unique: true
  end
end
