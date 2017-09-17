class AddColorToProjectStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :project_statuses, :color, :string
  end
end
