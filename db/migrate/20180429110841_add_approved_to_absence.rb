class AddApprovedToAbsence < ActiveRecord::Migration[5.1]
  def change
    add_column :absences, :approved, :boolean, default: false
  end
end
