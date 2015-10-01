class Receipt < ActiveRecord::Base
belongs_to :payment_type
belongs_to :user
belongs_to :project
belongs_to :provider

	def payment_type_name
		payment_type.try(:name)
	end

	def user_name
		user.try(:name)
	end

	def project_address
		project.try(:address)
	end

	def provider_name
			provider_id==0 ? 'Клиент' : provider.try(:name)
	end

  def purpose
  	  all_payd = project.receipts.where('provider_id = 0 and date <= ?', date).sum(:sum)
  		provider_id==0 ? project.project_type_name + ", " + ( all_payd*100/project.total ).to_s + '%' : ''
  end

end
