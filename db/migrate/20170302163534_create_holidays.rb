class CreateHolidays < ActiveRecord::Migration[4.2]
  def change
    create_table :holidays do |t|
			t.date :day
			t.string :name
      t.timestamps null: false
    end
  end
end
