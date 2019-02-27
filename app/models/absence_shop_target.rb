class AbsenceShopTarget < ActiveRecord::Base
  has_many :absences, foreign_key: :target_id
end
