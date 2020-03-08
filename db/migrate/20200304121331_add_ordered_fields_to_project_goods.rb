class AddOrderedFieldsToProjectGoods < ActiveRecord::Migration[5.1]
  def change
    add_column :project_goods, :order_provider_id, :integer
    add_column :project_goods, :order_currency_id, :integer
    add_column :project_goods, :order_goods_priority_id, :integer
    add_column :project_goods, :order_delivery_time_id, :integer
    add_column :project_goods, :order_name, :string
    add_column :project_goods, :order_description, :text
  end
end
