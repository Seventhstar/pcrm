class AddIcUserToLeads < ActiveRecord::Migration[4.2]
  def change
    add_column :leads, :ic_user_id, :integer
  end
end
