class ProjectGood < ActiveRecord::Base
  include CurrencyHelper
  belongs_to :provider
  belongs_to :project
  belongs_to :goodstype

  validates :name, :length => { :minimum => 3 }
  validates :provider_id, presence: true
  validates :gsum, presence: true

  def provider_name
    provider.try(:name)
  end

  def project_name
    project.try(:name)
  end

  def currency_print_name
    c = ''
    cpn = ['р.', 'евро', 'дол.']
    c = cpn[self.currency_id-1] if !self.currency_id.nil?
    c
  end

  def provider_full_info
    self.provider.full_info
  end

  def currency_name
    c = ''
    c = currency_src[self.currency_id-1][0] if !self.currency_id.nil?
    c
  end
end
