class AddSumToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :designer_sum, :integer
    add_column :projects, :visualer_sum, :integer
  end
end
