class AddPaydFullToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :payd_full, :boolean
  end
end
