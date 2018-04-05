class AddTargetToAbsence < ActiveRecord::Migration[4.2]
  def change
    add_column :absences, :target_id, :integer
  end
end
