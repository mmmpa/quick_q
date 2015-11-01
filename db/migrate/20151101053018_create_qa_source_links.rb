class CreateQaSourceLinks < ActiveRecord::Migration
  def change
    create_table :qa_source_links do |t|
      t.string :name, null: false
      t.string :url, null: false
    end

    add_index :qa_source_links, :url, unique: true
  end
end
