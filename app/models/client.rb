class Client < ActiveRecord::Base
	has_many :projects
	validates :name, :length => { :minimum => 3 }

end
