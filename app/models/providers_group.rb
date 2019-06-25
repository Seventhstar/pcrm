class ProvidersGroup < ApplicationRecord
  has_many :providers
  has_many :provider_goodstypes, as: :owner, foreign_key: :owner_id
  has_many :goodstypes, through: :provider_goodstypes

  accepts_nested_attributes_for :provider_goodstypes, allow_destroy: true

  def goods_type_names_array
    self.goodstypes.pluck(:name)
  end

  def goods_type_names
    self.goodstypes.pluck(:name).join(", ")
  end

  def goods_type_names_array
    self.goodstypes.pluck(:name)
  end

end
