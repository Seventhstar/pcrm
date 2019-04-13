class CostingRoom < ApplicationRecord
  belongs_to :costing
  belongs_to :room
  # has_one :cos_rooms, foreign_key: 'room_id', 
  # has_many :costings_rooms, through: :costing_rooms, dependent: :destroy

  def name
    room.try(:name)
  end

end
