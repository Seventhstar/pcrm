class AddPaydQToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :payd_q, :boolean
  end
end
