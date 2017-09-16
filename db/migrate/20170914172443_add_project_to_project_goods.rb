class AddProjectToProjectGoods < ActiveRecord::Migration
  def change
    add_reference :project_goods, :project, index: true
    add_reference :project_goods, :goodstype, index: true
    add_foreign_key :project_goods, :projects
    add_foreign_key :project_goods, :goodstypes
    remove_column :project_goods, :project_g_type_id
    change_column_default :project_goods, :fixed, false
  end
end
