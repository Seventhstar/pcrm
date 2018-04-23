class AddUserToSpecialInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :special_infos, :user_id, :integer
  end
end
