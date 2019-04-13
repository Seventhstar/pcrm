class CreateTarifs < ActiveRecord::Migration[5.1]
  def change
    create_table :tarifs do |t|
      t.references :project_type, foreign_key: true
      t.integer :sum
      t.integer :sum2
      t.references :tarif_calc_type, foreign_key: true
      t.integer :from
      t.float :designer_price
      t.integer :designer_price2
      t.integer :vis_price

      t.timestamps
    end
  end
end
