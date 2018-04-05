class ChangePayments < ActiveRecord::Migration[4.2]
  def up
    change_column_default(:payments, :verified, false)
  end
  
end
