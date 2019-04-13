class AddCostingTypeToCostings < ActiveRecord::Migration[5.1]
  def change
    add_reference :costings, :costings_type, foreign_key: true
    add_column :costings, :date_create, :date
  end
end
