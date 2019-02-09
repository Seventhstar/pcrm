class AddGoodsPriorityToProjectGoods < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_goods, :goods_priority, foreign_key: true, default: 1
  end
end
