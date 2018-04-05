class CreateClients < ActiveRecord::Migration[4.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
  end
end
