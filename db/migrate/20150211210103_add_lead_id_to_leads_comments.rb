class AddLeadIdToLeadsComments < ActiveRecord::Migration[4.2]
  def change
    add_column :leads_comments, :lead_id, :integer
  end
end
