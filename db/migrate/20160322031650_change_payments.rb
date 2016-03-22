class ChangePayments < ActiveRecord::Migration
  def up
    change_column_default(:payments, :verified, false)
  end
  
end
