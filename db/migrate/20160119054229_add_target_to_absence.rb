class AddTargetToAbsence < ActiveRecord::Migration
  def change
    add_column :absences, :target_id, :integer
  end
end
