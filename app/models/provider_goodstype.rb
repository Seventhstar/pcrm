class ProviderGoodstype < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :goodstype
  #belongs_to :provider, inverse_of: :provider
end
