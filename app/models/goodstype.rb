class Goodstype < ActiveRecord::Base
  has_many :provider_goodstypes
  has_many :providers, through: :provider_goodstypes
end
