class AddOrderToProjectStage < ActiveRecord::Migration[5.1]
  def change
    add_column :project_stages, :stage_order, :integer, default: 0
  end
end
