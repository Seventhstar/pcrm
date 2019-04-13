class AddUomToWork < ActiveRecord::Migration[5.1]
  def change
    add_reference :works, :uom, foreign_key: true
  end
end
