class AddPaidToReceipt < ActiveRecord::Migration[4.2]
  def change
    add_column :receipts, :paid, :boolean, default: false
  end
end
