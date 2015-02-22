class CreateProviderGoodstypes < ActiveRecord::Migration
  def change
    create_table :provider_goodstypes do |t|
      t.integer :provider_id
      t.integer :goodstype_id

      t.timestamps null: false
    end
    add_index :provider_goodstypes, :provider_id
    add_index :provider_goodstypes, :goodstype_id

  end
end
