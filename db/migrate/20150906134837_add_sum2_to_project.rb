class AddSum2ToProject < ActiveRecord::Migration
  def change
    add_column :projects, :date_sign, :datetime
    add_column :projects, :sum_total, :integer
    add_column :projects, :sum_2, :integer
  end
end
