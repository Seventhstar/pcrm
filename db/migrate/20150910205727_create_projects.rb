class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :client_id
      t.integer :number
      t.date :date_sign
      t.string :address
      t.integer :owner_id
      t.integer :executor_id
      t.integer :designer_id
      t.integer :project_type_id
      t.integer :style_id
      t.date :date_start
      t.date :date_end_plan
      t.date :date_end_real
      t.float :footage,          default: 0, :limit => 53
      t.float :footage_2,        default: 0, :limit => 53
      t.float :footage_real,     default: 0, :limit => 53
      t.float :footage_2_real,   default: 0, :limit => 53
      t.integer :price,          default: 0
      t.integer :price_2,        default: 0
      t.integer :price_real,     default: 0
      t.integer :price_2_real,   default: 0
      t.integer :sum,            default: 0
      t.integer :sum_2,          default: 0
      t.integer :sum_real,       default: 0
      t.integer :sum_2_real,     default: 0
      t.integer :sum_total,      default: 0
      t.integer :sum_total_real,    default: 0
      t.integer :month_in_gift
      t.boolean :act
      t.integer :delay_days

      t.timestamps null: false
    end
  end
end
