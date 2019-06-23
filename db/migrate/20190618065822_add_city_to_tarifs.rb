class AddCityToTarifs < ActiveRecord::Migration[5.1]
  def change
    add_reference :tarifs, :city, foreign_key: true, default: 1
  end
end
