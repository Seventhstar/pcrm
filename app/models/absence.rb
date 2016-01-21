class Absence < ActiveRecord::Base
	belongs_to :reason, class_name: "AbsenceReason", foreign_key: :reason_id
	belongs_to :target, class_name: "AbsenceTarget", foreign_key: :target_id
	belongs_to :user
	belongs_to :project
	has_many :shops, class_name: "AbsenceShop", foreign_key: :absence_id
	attr_accessor :t_from,:t_to, :checked
	has_paper_trail

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
