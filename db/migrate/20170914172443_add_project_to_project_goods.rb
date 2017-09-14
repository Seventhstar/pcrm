class AddProjectToProjectGoods < ActiveRecord::Migration
  def change
    add_reference :project_goods, :project, index: true
    add_foreign_key :project_goods, :projects
  end
end
