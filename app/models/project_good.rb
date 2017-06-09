class ProjectGood < ActiveRecord::Base
  include CurrencyHelper
  belongs_to :provider
  belongs_to :project_g_type
  validates :name, :length => { :minimum => 3 }
	validates :provider_id, presence: true
	validates :date_supply, presence: true
	validates :gsum, presence: true

	def provider_name
		provider.try(:name)
	end

	def currency_name
		c = ''
		c = currency_src[self.currency_id-1][0] if !self.currency_id.nil?
		c
	end
end
