class CreateDevProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :dev_projects do |t|
      t.string :name
      t.integer :priority_id

      t.timestamps null: false
    end
  end
end
