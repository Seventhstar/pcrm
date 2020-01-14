class ProjectType < ActiveRecord::Base
  has_many :projects
  has_many :project_stages
  def parents_count
    self.try(:projects).count
  end
end
