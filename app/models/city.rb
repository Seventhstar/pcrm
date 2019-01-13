class City < ApplicationRecord
  has_many :users
  has_many :leads
  has_many :projects
end
