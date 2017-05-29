class AddIndexToLeads < ActiveRecord::Migration
  def change
    add_index :leads, :status_id
    add_index :leads, :ic_user_id
  end
end
