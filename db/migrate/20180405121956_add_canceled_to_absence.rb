class AddCanceledToAbsence < ActiveRecord::Migration[5.1]
  def change
    add_column :absences, :canceled, :boolean
  end
end
