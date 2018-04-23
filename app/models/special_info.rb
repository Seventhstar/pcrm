class SpecialInfo < ApplicationRecord
  belongs_to :specialable, polymorphic: true, optional: true
  belongs_to :user
end
