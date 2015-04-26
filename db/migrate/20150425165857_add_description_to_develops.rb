class AddDescriptionToDevelops < ActiveRecord::Migration
  def change
    add_column :develops, :description, :text
    add_column :develops, :project_id, :integer
  end
end
