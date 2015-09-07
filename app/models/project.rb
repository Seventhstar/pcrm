class Project < ActiveRecord::Base
	belongs_to :client
	belongs_to :project_type

  def client_name
    client.try(:name)
  end

  def client_name=(name)
    self.client = Client.find_by_name(name) if name.present?
  end

  def project_type_name
  	project_type.try(:name)
  end

  def days_plan
     if date_end_plan? && date_start?
      (date_end_plan.to_date-date_start.to_date).to_i
     end
  end

  def sum_plan
    (footage*price_m).to_i
  end

  def sum_real
    (footage2*price_2).to_i
  end

end
