class AddSumTotalExecutorToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sum_total_executor, :integer
  end
end
