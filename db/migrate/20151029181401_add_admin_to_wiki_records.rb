class AddAdminToWikiRecords < ActiveRecord::Migration[4.2]
  def change
    add_column :wiki_records, :admin, :boolean, default: false
  end
end
