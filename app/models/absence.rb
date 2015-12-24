class Absence < ActiveRecord::Base
	belongs_to :reason, class_name: "AbsenceReason", foreign_key: :reason_id
	belongs_to :user
	belongs_to :project

	def reason_name
		reason.try(:name)
	end

	def user_name
		user.try(:name)
	end

	def project_name
		project.try(:address) 
	end
end
