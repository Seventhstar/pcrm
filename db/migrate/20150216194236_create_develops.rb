class CreateDevelops < ActiveRecord::Migration[4.2]
  def change
    create_table :develops do |t|
      t.string :name
      t.boolean :coder
      t.boolean :boss

      t.timestamps null: false
    end
  end
end
