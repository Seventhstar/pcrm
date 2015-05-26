class AddPriotityToDevelops < ActiveRecord::Migration
  def change
    add_column :develops, :priority_id, :integer
    add_column :develops, :ic_user_id, :integer
  end
end
