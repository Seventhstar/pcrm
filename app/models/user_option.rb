class UserOption < ActiveRecord::Base
has_many :users
#enum [:lead_created, :lead_updated]
#UserOptionsEnum = [:lead_created, :lead_updated, :lead_new_owner].freeze


end
