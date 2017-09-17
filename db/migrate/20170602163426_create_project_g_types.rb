class CreateProjectGTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :project_g_types do |t|
      t.integer :g_type_id
      t.integer :project_id
      t.timestamps null: false
    end
  end
end
