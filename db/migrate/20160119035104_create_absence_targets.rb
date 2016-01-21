class CreateAbsenceTargets < ActiveRecord::Migration
  def change
    create_table :absence_targets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
