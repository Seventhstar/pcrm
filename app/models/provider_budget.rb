class ProviderBudget < ActiveRecord::Base
  belongs_to :provider
  belongs_to :budget
  validates :name, :length => { :minimum => 3 }
end
