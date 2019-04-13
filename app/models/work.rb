class Work < ApplicationRecord
  belongs_to :work_type, optional: true
  belongs_to :uom
  has_many :work_linkers
  has_many :linked_works, through: :work_linkers
  has_many :rooms, through: :room_works
end
