class AddAdminToWikiRecords < ActiveRecord::Migration
  def change
    add_column :wiki_records, :admin, :boolean, default: false
  end
end
