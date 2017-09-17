class AddIndexProjectGType < ActiveRecord::Migration[5.1]
  def change
    add_index :project_g_types, :project_id
    add_index :project_g_types, :g_type_id
  
  end
end
