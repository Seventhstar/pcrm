class AddStatusToProject < ActiveRecord::Migration
  def change
    add_column :projects, :pstatus_id, :integer
  end
end
