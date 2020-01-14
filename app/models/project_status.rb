class ProjectStatus < ActiveRecord::Base
  has_many :projects, foreign_key: :pstatus_id
  def parents_count
    self.try(:projects).count
  end

end
