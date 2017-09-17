class AddIndexToLeads < ActiveRecord::Migration[5.1]
  def change
    add_index :leads, :status_id
    add_index :leads, :ic_user_id
  end
end
