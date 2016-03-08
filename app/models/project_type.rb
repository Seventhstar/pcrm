class ProjectType < ActiveRecord::Base
  has_many :projects
  def parents_count
    self.try(:projects).count
  end
end
