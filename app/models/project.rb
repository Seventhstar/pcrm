class Project < ActiveRecord::Base
  include ProjectsHelper
  include Comments
  attr_accessor :first_comment, :days, :sum_rest
  belongs_to :client
  belongs_to :executor, class_name: 'User', foreign_key: :executor_id
  belongs_to :project_type
  belongs_to :pstatus, class_name: 'ProjectStatus',foreign_key: :pstatus_id
  # has_many :comments, :as => :owner
  has_many :attachments, :as => :owner
  has_many :receipts
  has_many :project_g_types
  has_many :absence
  has_many :goods, class_name: "ProjectGood", dependent: :destroy
  has_many :elongations, class_name: 'ProjectElongation', dependent: :destroy


  validates :address, :length => { :minimum => 3 }
  validates :client_id, presence: true
  validates :footage, presence: true
  accepts_nested_attributes_for :client
  #validates_numericality_of :footage, greater_than: 1
  # belongs_to :project_elongation
  # accepts_nested_attributes_for :project_elongation, reject_if: :all_blank, allow_destroy: true

  has_paper_trail

  def client_name
    client.try(:name)
  end

  def client_name=(name)
    self.client = Client.find_by_name(name) if name.present?
  end

  def project_type_name
    n = project_type.try(:name)
    n = 'Вид не указан' if n.nil?
    n
  end

  def progress_proc
    pp = pstatus.try(:name)
    pp = pp + ' '+self.progress.to_s + '%' if !self.progress.nil? && self.progress>0
    pp
  end

  def executor_name
    executor.try(:name)
  end

  def status_name
    pstatus.try(:name)
  end
  def pstatus_name
    pstatus.try(:name)
  end

  def status_wname
    pstatus_id.nil? ? 'Без статуса' : pstatus.try(:name)
  end


  def days_duration
    if elongations.count>0
      business_days_between(date_start.to_datetime,last_elongation.to_datetime)+1
    elsif date_end_plan? && date_start?
      business_days_between(date_start.to_datetime,date_end_plan.to_datetime)+1
    end
  end

  def f1
    nil_footage(footage_real) ? footage.to_f : footage_real.to_f
  end

  def f2
    nil_footage(footage_real) ? footage_2.to_f : footage_2_real.to_f
  end

  def designer_sum_calc
    if !designer_sum.nil? && designer_sum > 0
      s = designer_sum 
    else
      s = designer_price.to_i * f1
      s = s + designer_price_2.to_i * f2 if footage_2>0
    end
    s.to_i
  end

  def visualer_sum_calc
    if !visualer_sum.nil? && visualer_sum > 0
      s = visualer_sum 
    else
      s = visualer_price.to_i * f1
    end
    s.to_i
  end  

  def executor_sum
    s = sum_total_executor
    s = (designer_sum_calc + visualer_sum_calc).to_i if s.nil?
    s
  end

  def rest
    sum_total_real==0 ? sum_total - executor_sum : sum_total_real - executor_sum
  end

  def executor_info
     i = f1_info + 'м.'
     i = [i,' - ',designer_price.to_s,'р.'].join if !designer_price.nil? && designer_price>0
     i = [i,'</br>',f2_info,'м.'].join if !nil_footage(f2_info)
     i = [i,' - ',designer_price_2.to_s,'р.'].join if !designer_price_2.nil? && designer_price_2>0
     i
  end

  def executor_prices
    p = ''
    p = designer_price.to_sum + 'р./м2' if designer_price.to_i>0
    p = p +' + '+ designer_price_2.to_sum + 'р./м2' if designer_price_2.to_i>0
    p
  end

  def prices()
    p = price.to_s
    p = p +' / '+ price_2.to_s if price_2.to_i>0
    p
  end

  def last_elongation
    new_date = ""
     if !elongations.nil? && elongations.count>0
        new_date = elongations.last.new_date
     end
     new_date
  end

  def date_end
    elongations.count==0 ? date_end_plan : last_elongation #elongations.last.new_date
  end

  def admin_info()
     i = [f1_info,'м.',' - ',price.to_s,'р.'].join
     i = i + '</br>'+ [f2_info,'м.',' - ',price_2.to_s,'р.'].join if !nil_footage(f2_info)
     i
  end

  def f1_info
    f = f1
    f = f.to_s[0..-3] if f.to_s[-2,2] == '.0'
    f = f.to_s.sub('.',',')
    f
  end

  def f2_info
    f = f2
    f = f.to_s[0..-3] if f.to_s[-2,2] == '.0'
    f = f.to_s.sub('.',',')
    f
  end

  def footage_info
    if !footage_real.nil? && footage_real!=0 && footage_real!= '0.0'
        f = footage_2_real.to_s=='0.0' ? footage_real : ['<b>',footage_real,' - ',designer_price,'</b>'].join
    else
        f = footage_2.to_s=='0.0' ? [footage,' - ',designer_price].join : [footage,' - ',designer_price].join
    end
    ['<span>',f,'</span>'].join
  end

  def plan_sum_by_hand?
    (sum_2 + sum) != sum_total
  end

  def real_sum_by_hand?
    (sum_2_real + sum_real) != sum_total_real
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
