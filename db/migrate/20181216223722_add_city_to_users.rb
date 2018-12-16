class AddCityToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :city, foreign_key: true, default: 1
  end
end
