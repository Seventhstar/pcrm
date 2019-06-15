class ProviderGoodstype < ActiveRecord::Base
  belongs_to :provider
  belongs_to :goodstype
end
