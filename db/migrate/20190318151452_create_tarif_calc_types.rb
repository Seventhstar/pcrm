class CreateTarifCalcTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :tarif_calc_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
