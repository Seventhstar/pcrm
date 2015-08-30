class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :client_id
      t.integer :number
      t.string :address
      t.integer :owner_id
      t.integer :executor_id
      t.integer :designer_id
      t.integer :project_type_id
      t.integer :style_id
      t.date :date_start
      t.date :date_end_plan
      t.date :date_end_real
      t.float :footage
      t.float :footage2
      t.float :footage_real
      t.float :footage2_real
      t.integer :sum
      t.integer :sum_real
      t.integer :price_m
      t.integer :price_2
      t.integer :price_real_m
      t.integer :price_real_2
      t.integer :month_in_gift
      t.boolean :act
      t.integer :delay_days

      t.timestamps null: false
    end
  end
end
