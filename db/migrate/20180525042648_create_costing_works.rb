class CreateCostingWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :costing_works do |t|
      t.references :costing, foreign_key: true
      t.references :work, foreign_key: true
      t.integer :qty
      t.float :price
      t.integer :amounth

      t.timestamps
    end
  end
end
