class AddPaydFullToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :payd_full, :boolean
  end
end
