class CreateStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :statuses do |t|
      t.string :name
      t.boolean :actual

      t.timestamps null: false
    end
  end
end
