class AddGoodsPriorityToProjectGoods < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_goods, :goods_priority, default: 1
  end
end
