class CreateProviderManagers < ActiveRecord::Migration
  def change
    create_table :provider_managers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :provider_id

      t.timestamps null: false
    end
    add_index :provider_managers, :provider_id
  end
end
