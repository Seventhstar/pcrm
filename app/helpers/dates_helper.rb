module DatesHelper
  def format_date(date_time)
    date_time.try('strftime',"%d.%m.%Y")
  end

  def format_datetime(date_time)
    date_time.try('strftime',"%Y.%m.%d %H:%M")
  end

  def format_dateseconds(date_time, year_first = true, local = true)
    mformat = year_first ? "%Y.%m.%d %H:%M:%S" : "%d.%m.%Y %H:%M:%S"
    

    date_time.try('strftime', mformat)
  end
   
  def month_year(date)
    "#{t date.try('strftime','%B')} #{date.try('strftime','%Y')}"
  end
end
