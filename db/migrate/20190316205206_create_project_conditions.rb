class CreateProjectConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :project_conditions do |t|
      t.boolean :closed
      t.references :project
      t.timestamps
    end
  end
end
