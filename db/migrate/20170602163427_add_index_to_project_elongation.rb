class AddIndexToProjectElongation < ActiveRecord::Migration[5.1]
  def change
    add_index :project_elongations, :project_id
  end
end
