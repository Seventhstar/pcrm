class Index < ActiveRecord::Migration
  def up
    add_index :receipts, :paid
  end
  
end
