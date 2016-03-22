class AddPaymentToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :payment_id, :integer
  end
end
