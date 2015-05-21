class PStatus < ActiveRecord::Base
  has_many :providers
  attr_accessor :parents_count
  
  def parents_count
    self.try(:providers).count
  end

end
