class Absence < ActiveRecord::Base
	belongs_to :absence_reason, foreign_key: :reason_id
end
