class CreateWikiCats < ActiveRecord::Migration[5.1]
  def change
    create_table :wiki_cats do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
