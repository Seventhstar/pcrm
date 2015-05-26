class DevProject < ActiveRecord::Base
  has_many :develops, foreign_key: :project_id

  attr_accessor :parents_count

  def parents_count
    self.try(:develops).count
  end


end


