class Client < ActiveRecord::Base
	has_many :projects
  has_many :contacts, as: :contactable

  accepts_nested_attributes_for :contacts
	# validates :name, :length => { :minimum => 3 } 

end
