class AddCityToProviders < ActiveRecord::Migration[5.1]
  def change
    add_reference :providers, :city, foreign_key: true, default: 1
  end
end
