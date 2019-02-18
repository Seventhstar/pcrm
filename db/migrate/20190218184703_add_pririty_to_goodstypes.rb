class AddPrirityToGoodstypes < ActiveRecord::Migration[5.1]
  def change
    add_column :goodstypes, :priority, :integer, default: 100
  end
end
