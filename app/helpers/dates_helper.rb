module DatesHelper
  def format_date(datetime)
    datetime.try('strftime',"%d.%m.%Y")
  end

  def js_date(datetime)
    datetime.try('strftime',"%Y-%m-%d")
  end

  def format_datetime(datetime)
    datetime.try('strftime',"%Y.%m.%d %H:%M")
  end

  def format_dateseconds(datetime, year_first = true, local = true)
    mformat = year_first ? "%Y.%m.%d %H:%M:%S" : "%d.%m.%Y %H:%M:%S"
    datetime.try('strftime', mformat)
  end

  def f_time(date_time)
    date_time.try('strftime',"%H:%M")
  end 

  def month_year(date)
    "#{t date.try('strftime','%B')} #{date.try('strftime','%Y')}"
  end

  def year_month(date)
    "#{date.try('strftime','%Y')} #{date.try('strftime','%m')}"
  end
end
