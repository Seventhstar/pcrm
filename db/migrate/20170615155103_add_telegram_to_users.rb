class AddTelegramToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :telegram, :string
  end
end
