class CreateConsumptions < ActiveRecord::Migration[5.1]
  def change
    create_table :consumptions do |t|
      t.string :name

      t.timestamps
    end
  end
end
