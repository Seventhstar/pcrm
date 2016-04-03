class MyValidator < ActiveModel::Validator
  def validate(record)
  	if !(record.id.nil? && record.reason_id==3)     
      record.errors.add('Магазины', "добавьте хотя бы один") if record.shops.count==0 && record.reason_id==3   
     end
  end
end

class Absence < ActiveRecord::Base
	extend ActiveModel::Naming

	belongs_to :reason, class_name: "AbsenceReason", foreign_key: :reason_id
	belongs_to :new_reason, class_name: "AbsenceReason", foreign_key: :new_reason_id
	belongs_to :target, class_name: "AbsenceTarget", foreign_key: :target_id
	belongs_to :user
	belongs_to :project
	has_many :shops, class_name: "AbsenceShop", foreign_key: :absence_id
	attr_accessor :t_from,:t_to, :checked, :reopen
	has_paper_trail

	validates_with MyValidator	
	validates :reason_id, presence: true
	validates :user, presence: true
	validates :project_id, presence: true, if: Proc.new { |p| p.project_id.nil? && (p.reason_id==2 || p.reason_id==3) }  
	validates :target_id, presence: true, if: Proc.new { |p| p.target_id.nil? && p.reason_id==2  } 

	def reason_name
		reason.try(:name)
	end

	def new_reason_name
		new_reason.try(:name)
	end

	def user_name
		user.try(:name)
	end

	def project_name
		project.try(:address) 
	end

	def target_name
		target.try(:name)
	end

end
