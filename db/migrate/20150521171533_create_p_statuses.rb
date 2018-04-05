class CreatePStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :p_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
