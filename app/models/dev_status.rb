class DevStatus < ActiveRecord::Base
  has_many :develops

  attr_accessor :parents_count

  def parents_count
    self.try(:develops).count
  end

end
