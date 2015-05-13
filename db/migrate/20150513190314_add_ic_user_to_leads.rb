class AddIcUserToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :ic_user_id, :integer
  end
end
