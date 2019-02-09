class CreateWorkingDays < ActiveRecord::Migration[5.1]
  def change
    create_table :working_days do |t|
      t.date :day
      t.string :name

      t.timestamps
    end
  end
end
