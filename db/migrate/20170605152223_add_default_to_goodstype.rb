class AddDefaultToGoodstype < ActiveRecord::Migration[5.1]
  def change
    add_column :goodstypes, :default, :boolean
  end
end
