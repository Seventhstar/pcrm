class AddCityToProviders < ActiveRecord::Migration[5.1]
  def change
    add_reference :providers, :city, default: 1
  end
end
