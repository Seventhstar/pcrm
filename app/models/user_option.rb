class UserOption < ActiveRecord::Base
belongs_to :user
#enum [:lead_created, :lead_updated]
UserOptionsEnum = [:lead_created, :lead_updated, :lead_new_owner].freeze


end
