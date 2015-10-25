class CreateWikiRecords < ActiveRecord::Migration
  def change
    create_table :wiki_records do |t|
      t.string :name
      t.text :description
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
