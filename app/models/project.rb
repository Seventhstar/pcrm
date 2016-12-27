class Project < ActiveRecord::Base
	belongs_to :client
  belongs_to :executor, class_name: 'User', foreign_key: :executor_id
	belongs_to :project_type
  belongs_to :pstatus, class_name: 'ProjectStatus',foreign_key: :pstatus_id
  has_many :comments, :as => :owner
  has_many :receipts
  has_many :absence

  attr_accessor :first_comment
  has_many :elongations, class_name: 'ProjectElongation'

  validates :address, :length => { :minimum => 3 }
  validates :footage, presence: true
  #validates_numericality_of :footage, greater_than: 1
  include ProjectsHelper
	accepts_nested_attributes_for :client
  has_paper_trail

  def client_name
    client.try(:name)
  end

  def client_name=(name)
    self.client = Client.find_by_name(name) if name.present?
  end

  def project_type_name
  	project_type.try(:name)
  end

  def executor_name
    executor.try(:name)
  end

  def status_name
    pstatus.try(:name)
  end

  def days_plan
     if date_end_plan? && date_start?
      business_days_between(date_start.to_datetime,date_end_plan.to_datetime)+1
     end
  end

  def designer_sum()
    s = designer_price.to_i * footage.to_f
    s = s + designer_price_2.to_i * footage_2.to_f if footage_2>0
    s.to_i
  end

  def executor_sum()
    (designer_sum + visualer_price.to_i * footage.to_f).to_i
  end

  def rest()
    sum_total_real==0 ? sum_total - executor_sum : sum_total_real - executor_sum
  end

  def executor_prices()
    p = designer_price.to_s
    p = p +'/'+ designer_price_2.to_s if designer_price_2.to_i>0
    p
  end

  def prices()
    p = price.to_s
    p = p +'/'+ price_2.to_s if price_2.to_i>0
    p
  end

  def last_elongation
     if !elongations.nil?
        new_date = elongations.last
        if new_date
          new_date.new_date.try('strftime',"%d.%m.%Y")
        end
     end
  end

  def footage_info
    if !footage_real.nil? && footage_real!=0 && footage_real!= '0.0'
        f = footage_2_real.to_s=='0.0' ? footage_real : ['<b>',footage_real,'+',footage_2_real,'</b>'].join
    else
        f = footage_2.to_s=='0.0' ? footage : [footage,'+',footage_2].join
    end
    ['<span>',f,'</span>'].join
  end

  def sum_plan
    (footage*price).to_i
  end

  def sum_2
    (footage_2*price_2).to_i
  end

  def sum_real
    (footage_real.to_f*price_real).to_i
  end

  def sum_2_real
    (footage_2_real*price_2_real).to_i
  end

  def total
     sum_total_real==0 ? sum_total : sum_total_real
  end

end
