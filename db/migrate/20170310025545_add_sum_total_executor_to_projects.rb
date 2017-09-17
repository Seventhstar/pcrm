class AddSumTotalExecutorToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :sum_total_executor, :integer
  end
end
