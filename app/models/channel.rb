class Channel < ActiveRecord::Base
 has_many :leads
 validates :name, length: { minimum: 3 }

  attr_accessor :parents_count
  
  def parents_count
    self.try(:leads).count
  end


end
