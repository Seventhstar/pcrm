class CreatePStatuses < ActiveRecord::Migration
  def change
    create_table :p_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
