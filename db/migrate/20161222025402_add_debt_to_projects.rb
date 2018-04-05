class AddDebtToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :debt, :boolean
    add_column :projects, :interest, :boolean
  end
end
