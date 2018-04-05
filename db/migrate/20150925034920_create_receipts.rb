class CreateReceipts < ActiveRecord::Migration[4.2]
  def change
    create_table :receipts do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :provider_id
      t.integer :payment_type_id
      t.date :date
      t.integer :sum
      t.string :description

      t.timestamps null: false
    end
  end
end
