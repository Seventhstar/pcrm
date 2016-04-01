class MyValidator < ActiveModel::Validator
  def validate(record)
  	record.errors.add('Причина','не указана') if record.reason_id.nil?
  	record.errors.add('Сотрудник', "не указан") if record.user_id.to_i<1 
  	record.errors.add('Проект', "не указан") if record.project_id.to_i==0 && (record.reason_id==2 || record.reason_id==3)
  	record.errors.add('Цель', "не указана") if record.target_id.to_i==0 && record.reason_id==2
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
	validates :reason_id, :length => { :minimum => 3 }

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
