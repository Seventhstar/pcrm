class LeadSource < ActiveRecord::Base
  has_many :leads, foreign_key: :source_id
end
