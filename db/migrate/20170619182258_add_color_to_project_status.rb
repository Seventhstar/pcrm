class AddColorToProjectStatus < ActiveRecord::Migration
  def change
    add_column :project_statuses, :color, :string
  end
end
