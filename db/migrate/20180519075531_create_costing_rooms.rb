class CreateCostingRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :costing_rooms do |t|
      t.references :costing, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
