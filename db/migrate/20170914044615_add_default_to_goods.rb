class AddDefaultToGoods < ActiveRecord::Migration[5.1]
  def change
    change_column_default :project_goods, :order, false
  end
end
