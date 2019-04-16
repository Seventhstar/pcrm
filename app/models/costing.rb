class Costing < ApplicationRecord
  belongs_to :project
  belongs_to :user
  # belongs_to :owner, class_name: 'User', foreign_key: :user_id
  belongs_to :costings_type
  # has_many :rooms, through: 
  has_many :costing_works
  
  # has_many :costings_rooms, through: :costing_rooms
  has_many :costing_rooms, dependent: :destroy
  has_many :rooms, through: :costing_rooms, dependent: :destroy

  attr_accessor :project_address, :room_id
  # accepts_nested_attributes_for :costings_works, allow_destroy: true
  accepts_nested_attributes_for :costing_rooms, allow_destroy: true

  def project_address
    project.try(:address)
  end

  def costings_type_name 
    costings_type.try(:name)
  end

  def user_name
    user.try(:name)
  end
end
