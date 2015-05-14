class ProviderGoodstype < ActiveRecord::Base
  belongs_to :provider
  belongs_to :goodstype
  validates :name, :length => { :minimum => 3 }

end
