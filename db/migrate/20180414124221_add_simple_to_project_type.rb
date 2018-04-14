class AddSimpleToProjectType < ActiveRecord::Migration[5.1]
  def change
    add_column :project_types, :simple, :boolean, default: false
  end
end
