class AddDebtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :debt, :boolean
    add_column :projects, :interest, :boolean
  end
end
