class ProviderGoodstype < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :goodstype
end
