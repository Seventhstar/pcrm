class AbsenceTarget < ActiveRecord::Base
	has_many :absences, foreign_key: :target_id

	def parents_count
    self.try(:absences).count
  end
  
end
