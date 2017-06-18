class AddFixedToProjectGoods < ActiveRecord::Migration
  def change
    add_column :project_goods, :sum_supply, :integer
    add_column :project_goods, :fixed, :boolean
    add_index :project_goods, :fixed
  end
end
