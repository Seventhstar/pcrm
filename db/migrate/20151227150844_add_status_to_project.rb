class AddStatusToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :pstatus_id, :integer
  end
end
