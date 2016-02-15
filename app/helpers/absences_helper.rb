module AbsencesHelper

  def day_abs(day)
    Absence.where(:dt_from => day.beginning_of_day..day.end_of_day)
  end
end
