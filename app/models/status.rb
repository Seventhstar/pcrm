class Status < ActiveRecord::Base
 has_many :leads

  attr_accessor :parents_count
  
  def parents_count
    self.try(:leads).count
  end

end
