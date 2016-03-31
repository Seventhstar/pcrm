class AddSourceToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :source_id, :integer
  end
end
