class ProviderBudget < ActiveRecord::Base
  belongs_to :provider
  belongs_to :budget

end
