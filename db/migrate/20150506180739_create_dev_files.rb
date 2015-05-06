class CreateDevFiles < ActiveRecord::Migration
  def change
    create_table :dev_files do |t|
      t.string :develop_id
      t.string :name

      t.timestamps null: false
    end
    add_index :dev_files, :develop_id
  end
end
