class Payment < ActiveRecord::Base

	belongs_to :payment_type
	belongs_to :payment_purpose
	belongs_to :user
	belongs_to :project
	belongs_to :whom, :polymorphic => true
	has_paper_trail

	def payment_type_name
		payment_type.try(:name)
	end

	def project_address
		try(:project).try(:address)
	end

	def purpose_name
		payment_purpose.try(:name)
	end

	def user_name
		user.try(:name)
	end

	def whom_name
		whom.try(:name)
	end
end
