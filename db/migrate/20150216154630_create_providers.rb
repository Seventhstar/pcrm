class CreateProviders < ActiveRecord::Migration[4.2]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :manager
      t.string :phone
      t.string :komment
      t.string :address
      t.string :email
      t.string :url
      t.string :spec

      t.timestamps null: false
    end
  end
end
