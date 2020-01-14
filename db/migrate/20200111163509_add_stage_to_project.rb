class AddStageToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :project_stage_id, :integer
  end
end
