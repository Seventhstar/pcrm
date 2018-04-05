class AddSourceToLeads < ActiveRecord::Migration[4.2]
  def change
    add_column :leads, :source_id, :integer
  end
end
