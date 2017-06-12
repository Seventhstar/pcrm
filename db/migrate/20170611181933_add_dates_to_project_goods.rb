class AddDatesToProjectGoods < ActiveRecord::Migration
  def change
    add_column :project_goods, :date_offer, :date
    add_column :project_goods, :date_place, :date
  end
end
