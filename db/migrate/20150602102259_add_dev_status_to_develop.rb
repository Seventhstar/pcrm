class AddDevStatusToDevelop < ActiveRecord::Migration
  def change
    add_column :develops, :dev_status_id, :integer

  add_index :develops, :dev_status_id
  add_index :develops, :priority_id
  add_index :develops, :ic_user_id
  end
end
