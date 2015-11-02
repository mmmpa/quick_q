class CreateQaTags < ActiveRecord::Migration
  def change
    create_table :qa_tags do |t|
      t.string :name, null:false
      t.string :display, null:false
    end

    add_index :qa_tags, :name, unique: true
    add_index :qa_tags, :display, unique: true
  end
end
