class CreateDevStatuses < ActiveRecord::Migration
  def change
    create_table :dev_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
