class AddIndexToProjectElongation < ActiveRecord::Migration
  def change
    add_index :project_elongations, :project_id
  end
end
