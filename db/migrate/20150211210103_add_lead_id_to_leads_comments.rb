class AddLeadIdToLeadsComments < ActiveRecord::Migration
  def change
    add_column :leads_comments, :lead_id, :integer
  end
end
