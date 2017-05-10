class CreateProjectGoods < ActiveRecord::Migration
  def change
    create_table :project_goods do |t|
      t.integer :project_g_type_id
      t.string :name
      t.integer :provider_id
      t.date :date_supply
      t.text :description
      t.boolean :order
      t.integer :currency_id
      t.integer :gsum

      t.timestamps null: false
    end
  end
end
