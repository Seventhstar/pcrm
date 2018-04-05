class CreateDevelopsFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :develops_files do |t|
      t.string :develop_id
      t.string :name

      t.timestamps null: false
    end
    add_index :develops_files, :develop_id
  end
end
