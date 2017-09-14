class UserOption < ActiveRecord::Base
has_many :users
  #enum [:lead_created, :lead_updated]
  #UserOptionsEnum = [:lead_created, :lead_updated, :lead_new_owner].freeze

  def self.users_ids(id)
    id.nil? ? [] : self.where(option_id: id).pluck(:user_id)
  end

end
