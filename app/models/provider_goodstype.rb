class ProviderGoodstype < ActiveRecord::Base
  belongs_to :goodstype
  belongs_to :provider
end
