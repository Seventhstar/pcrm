class ElongationTypeToProjectElongation < ActiveRecord::Migration
  def change
      add_column :project_elongations, :elongation_type_id, :integer
      remove_column :project_elongations, :description
  end
end
