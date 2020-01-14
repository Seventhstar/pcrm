class CreateProjectStages < ActiveRecord::Migration[5.1]
  def change
    create_table :project_stages do |t|
      t.string :name
      t.string :color
      t.integer :part
      t.references :project_type, foreign_key: true
      t.timestamps
    end
  end
end
