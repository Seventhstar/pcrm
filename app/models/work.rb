class Work < ApplicationRecord
  belongs_to :work_type, optional: true
  has_many :work_linkers
  has_many :linked_works, through: :work_linkers
end