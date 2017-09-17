class AddCatToWikiRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :wiki_records, :wiki_cat_id, :integer
    add_index :wiki_records, :wiki_cat_id
  end
end
