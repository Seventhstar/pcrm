class AddDefaultToGoods < ActiveRecord::Migration
  def change
    change_column_default :project_goods, :order, false
  end
end
