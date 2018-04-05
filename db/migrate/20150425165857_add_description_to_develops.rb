class AddDescriptionToDevelops < ActiveRecord::Migration[4.2]
  def change
    add_column :develops, :description, :text
    add_column :develops, :project_id, :integer
  end
end
