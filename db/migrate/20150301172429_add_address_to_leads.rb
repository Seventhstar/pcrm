class AddAddressToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :address, :string
  end
end
