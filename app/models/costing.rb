class Costing < ApplicationRecord
  belongs_to :project
  belongs_to :user
  attr_accessor :project_address
end
