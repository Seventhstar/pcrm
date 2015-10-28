class CreateWikiFiles < ActiveRecord::Migration
  def change
    create_table :wiki_files do |t|
      t.integer :user_id
      t.integer :wiki_record_id
      t.string :name

      t.timestamps null: false
    end
    add_index :wiki_files, :wiki_record_id
  end
end
