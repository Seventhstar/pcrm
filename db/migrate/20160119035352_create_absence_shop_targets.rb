class CreateAbsenceShopTargets < ActiveRecord::Migration[4.2]
  def change
    create_table :absence_shop_targets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
