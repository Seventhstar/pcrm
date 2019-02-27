class AddPrirityToDeliveryTimes < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_times, :priority, :integer, default: 100
  end
end
