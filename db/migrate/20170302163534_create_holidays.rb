class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
			t.date :day
			t.string :name
      t.timestamps null: false
    end
  end
end
