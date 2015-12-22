class CreateAbsenceReasons < ActiveRecord::Migration
  def change
    create_table :absence_reasons do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
