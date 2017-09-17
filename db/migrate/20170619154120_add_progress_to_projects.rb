class AddProgressToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :progress, :integer
  end
end
