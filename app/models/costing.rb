class Costing < ApplicationRecord
  belongs_to :project
  # belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  belongs_to :costings_type
  has_many :costing_rooms
  has_many :rooms, through: :costing_rooms
  attr_accessor :project_address

  def project_address()
    project.try(:address)
  end

  def owner_name()
    owner.try(:name)
  end
end
