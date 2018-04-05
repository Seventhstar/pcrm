class ElongationTypeToProjectElongation < ActiveRecord::Migration[4.2]
  def change
      add_column :project_elongations, :elongation_type_id, :integer
      remove_column :project_elongations, :description
  end
end
