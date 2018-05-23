class Room < ApplicationRecord
  has_many :room_works
  has_many :works, through: :room_works
end
