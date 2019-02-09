class AddDeliveryTimeToProjectGoods < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_goods, :delivery_time, foreign_key: true, default: 1
  end
end
