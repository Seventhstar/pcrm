class AddFiredToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fired, :boolean, default: false
  end
end
