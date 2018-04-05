class CreateProjectElongations < ActiveRecord::Migration[4.2]
  def change
    create_table :project_elongations do |t|
      t.date :new_date
      t.string :description
      t.integer :project_id
      t.timestamps null: false
    end
  end
end
