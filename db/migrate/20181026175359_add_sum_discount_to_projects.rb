class AddSumDiscountToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :sum_discount, :integer, default: 0
  end
end
