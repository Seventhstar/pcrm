class AddPaidToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :paid, :boolean, default: false
  end
end
