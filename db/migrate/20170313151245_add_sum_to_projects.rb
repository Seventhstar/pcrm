class AddSumToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :designer_sum, :integer
    add_column :projects, :visualer_sum, :integer
  end
end
