class AddDateBirthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_birth, :datetime
  end
end
