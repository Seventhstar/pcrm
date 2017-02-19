class AddPaydQToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :payd_q, :boolean
  end
end
