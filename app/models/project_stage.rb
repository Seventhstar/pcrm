class ProjectStage < ApplicationRecord
  has_many :projects, foreign_key: :project_stage_id
  belongs_to :project_type, optional: true
  
  def parents_count
    self.try(:projects).count
  end

  def order
    self.stage_order == 0 ? self.id : self.stage_order
  end

end
