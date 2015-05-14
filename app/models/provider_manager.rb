class ProviderManager < ActiveRecord::Base
  belongs_to :provider
  validates :name, :length => { :minimum => 3 }
end
