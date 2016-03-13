class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :whom_id
      t.string :whom_type
      t.integer :payment_type_id
      t.integer :payment_purpose_id
      t.date :date
      t.integer :sum
      t.boolean :verified
      t.string :description

      t.timestamps null: false
    end
  end
end
