class AbsenceReason < ActiveRecord::Base
  has_many :absences, foreign_key: :reason_id

  def parents_count
    predef = id < 2 ? 1 : 0
    self.try(:absences).count | predef
  end

end
