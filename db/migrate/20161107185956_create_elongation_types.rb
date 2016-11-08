class CreateElongationTypes < ActiveRecord::Migration
  def change
    create_table :elongation_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
