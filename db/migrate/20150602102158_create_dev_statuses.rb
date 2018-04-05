class CreateDevStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :dev_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
