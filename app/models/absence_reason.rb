class AbsenceReason < ActiveRecord::Base
  has_many :absences, foreign_key: :reason_id

  def parents_count
    predef = id < 2 ? 1 : 0
    self.try(:absences).count | predef
  end

  def diff_hours()
    diff = (self.date_from - self.date_to) / 1000
    diff /= (3600)
    diff = abs(diff)
    if (diff > 6) 
      diff = diff - 1
    end
    diff
  end

end
