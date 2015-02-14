class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.boolean :actual

      t.timestamps null: false
    end
  end
end
