class CreateSelectionSelections < ActiveRecord::Migration
  def change
    create_table :selection_selections do |t|
      t.string :name, null: false
      t.integer :choice_type, null: false
      t.integer :total

      t.timestamps null: false
    end
  end
end
