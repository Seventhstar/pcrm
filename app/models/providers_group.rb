class ProvidersGroup < ApplicationRecord
  has_many :providers
  has_many :provider_goodstypes, as: :owner
  has_many :goodstypes, through: :provider_goodstypes

  def goods_type_names_array
    self.goodstypes.pluck(:name)
  end

end
