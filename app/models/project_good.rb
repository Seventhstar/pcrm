class ProjectGood < ActiveRecord::Base
  include CurrencyHelper
  belongs_to :provider
  belongs_to :project
  belongs_to :goodstype
  belongs_to :currency
  attr_accessor :owner_id

  validates :name, length: { minimum: 3 }
  validates :provider_id, presence: true
  validates :gsum, presence: true
  scope :by_year, ->(year){where(date_place: Date.new(year.to_i,1,1)..Date.new(year.to_i,12,31)) if year.present? && year&.to_i>0}
  scope :currency, ->(c){where(currency_id: c) if c.present?}
  scope :good_state, ->(gs){
    case gs
    when '1'
      where(order: false)
    when '2'
      where(order: true, fixed: false)
    when '3'
      where(fixed: true)
    end
  }

  def provider_name
    provider.try(:name)
  end

  def project_name
    project.try(:name)
  end

  def last_sum
    self.sum_supply.nil? ? self.gsum : self.sum_supply
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
    self.currency_id.nil? ? '' : currency_src[self.currency_id-1][0]
  end
end
