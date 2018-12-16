class AddCityToLeads < ActiveRecord::Migration[5.1]
  def change
    add_reference :leads, :city, foreign_key: true, default: 1
  end
end
