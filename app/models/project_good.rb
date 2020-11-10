class ProjectGood < ActiveRecord::Base
  include CurrencyHelper
  belongs_to :provider
  belongs_to :order_provider, class_name: 'Provider', optional: true
  belongs_to :project
  belongs_to :goodstype
  
  belongs_to :currency
  belongs_to :order_currency, class_name: 'Currency', optional: true

  belongs_to :delivery_time
  belongs_to :goods_priority
  attr_accessor :group_id, :group
  attr_accessor :file_cache

  has_paper_trail
  has_many :attachments, as: :owner

  validates :name, length: { minimum: 3 }
  validates :provider_id, presence: true
  validates :gsum, presence: true
  validates :goods_priority_id, presence: true

  scope :currency, -> (c) {where(currency_id: c) if c.present?}
  scope :only_actual, -> (ids, only_actual) {where(project_id: ids) if only_actual}
  scope :by_project_ids, -> (ids, force_year) {where(project_id: ids) if ids.present? || force_year}
  
  scope :by_executor, ->(executor_ids, force_executor){
    where(project_id: executor_ids) if executor_ids.present? || force_executor
  }

  # before_validation
  before_validation :strip_whitespace, only: [:name, :description]

  
  scope :good_state, -> (gs) {
    case gs
    when '1'
      where(order: false)
    when '2'
      where(order: true, fixed: false)
    when '3'
      where(fixed: true)
    end
  }

  def strip_whitespace
    self.name = self.name.strip.capitalize unless self.name.nil?
    self.description = self.description.strip.capitalize unless self.description.nil?
    if self.description.include?('. ')
       d = self.description.split('. ')
       d.each do |dp|
          # puts "dp #{dp}"
          dp.capitalize!
       end
       self.description = d.join('. ')
    end
  end

  def provider_name
    provider.try(:name)
  end

  def order_provider_name
    order_provider.try(:name)
  end

  def project_name
    project.try(:name)
  end

  def last_sum
    self.sum_supply.nil? ? self.gsum : self.sum_supply
  end

  def print_amount
    self.gsum.to_sum + currency.try(:short)
  end

  def currency_print_name
    c = ''
    cpn = ['р.', 'дол.', 'евро']
    c = cpn[self.currency_id-1] if !self.currency_id.nil?
    c
  end

  def provider_full_info
    self.provider&.full_info
  end

  def currency_short
    currency.try(:short)
  end

  def order_currency_short
    order_currency.try(:short)
  end

  def currency_name
    self.currency_id.nil? ? '' : currency_src[self.currency_id-1][0]
  end
end
