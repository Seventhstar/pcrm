class ProjectElongation < ActiveRecord::Base
	belongs_to :project
	belongs_to :elongation_type


	def description
    elongation_type.try(:name)
  end
end
