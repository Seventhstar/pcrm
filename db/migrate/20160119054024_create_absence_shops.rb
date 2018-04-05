class CreateAbsenceShops < ActiveRecord::Migration[4.2]
  def change
    create_table :absence_shops do |t|
      t.integer :absence_id
      t.integer :shop_id
      t.integer :target_id

      t.timestamps null: false
    end
  end
end
