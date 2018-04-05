class AddPaymentToReceipt < ActiveRecord::Migration[4.2]
  def change
    add_column :receipts, :payment_id, :integer
  end
end
