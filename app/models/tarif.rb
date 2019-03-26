class Tarif < ApplicationRecord
  belongs_to :project_type
  belongs_to :tarif_calc_type

  def project_type_name
    project_type.try(:name)
  end

  def tarif_calc_type_name
    tarif_calc_type.try(:name)
  end

end
