class AddCityToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :city, default: 1
  end
end
