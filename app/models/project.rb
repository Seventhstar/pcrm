class Project < ActiveRecord::Base
	belongs_to :client
  belongs_to :executor, class_name: 'User', foreign_key: :executor_id
	belongs_to :project_type
  belongs_to :project_status
  has_many :receipts
  has_many :absence
	accepts_nested_attributes_for :client

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

  def days_plan
     if date_end_plan? && date_start?
      (date_end_plan.to_date-date_start.to_date).to_i
     end
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
