class Costing < ApplicationRecord
  belongs_to :project
  # belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  attr_accessor :project_address

  def project_address()
    project.try(:address)
  end

  def owner_name()
    owner.try(:name)
  end
end
