class Index < ActiveRecord::Migration[4.2]
  def up
    add_index :receipts, :paid
  end
  
end
