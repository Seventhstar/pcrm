class LeadsFile < ActiveRecord::Base
 belongs_to :user
 belongs_to :lead
 has_paper_trail
end
