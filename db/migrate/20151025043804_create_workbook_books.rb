class CreateWorkbookBooks < ActiveRecord::Migration
  def change
    create_table :workbook_books do |t|
      t.string :name, null: false
      t.integer :eval_type, null: false
      t.integer :passing, null: false

      t.timestamps null: false
    end
  end
end
