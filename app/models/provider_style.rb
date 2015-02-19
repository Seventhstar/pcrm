class ProviderStyle < ActiveRecord::Base
  belongs_to :provider
  belongs_to :style
end
