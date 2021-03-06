class CreateLeads < ActiveRecord::Migration[4.2]
  def change
    create_table :leads do |t|
      t.string :info
      t.string :fio
      t.integer :footage
      t.string :phone
      t.string :email
      t.integer :channel_id
      t.integer :status_id
      t.integer :user_id
      t.date :status_date

      t.timestamps null: false
    end
  end
end
