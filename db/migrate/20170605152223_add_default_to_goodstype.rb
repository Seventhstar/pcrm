class AddDefaultToGoodstype < ActiveRecord::Migration
  def change
    add_column :goodstypes, :default, :boolean
  end
end
