class ProviderStyle < ActiveRecord::Base
  belongs_to :provider
  belongs_to :style
  validates :name, :length => { :minimum => 3 }
end
