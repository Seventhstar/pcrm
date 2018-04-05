class AddDateBirthToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :date_birth, :datetime
  end
end
