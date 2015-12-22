class AbsenceReason < ActiveRecord::Base
	has_many :absences, foreign_key: :reason_id
end
