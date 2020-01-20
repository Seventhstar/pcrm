module AbsencesHelper

  def day_abs(day)
    #Absence.where(dt_from: day.beginning_of_day..day.end_of_day)
    Absence.where(user_id: @user_ids).where('dt_from <= ? and dt_to >= ?', day.end_of_day, day.beginning_of_day)
  end

  def day_class(day, month)
    cls = "day"
    cls = cls + ' nday' if day.beginning_of_month != month.beginning_of_month
    cls = cls + ' curday' if day.beginning_of_day == Date.today
    cls = cls + ' before' if day.beginning_of_day < Date.today
    cls
  end

  def date_class(day)
    cls = "numday date"
    cls = cls + ' curday' if day.beginning_of_day == Date.today
    cls
  end

  def abs_class(abs)
    cls = "abs"+abs.reason_id.to_s 
    cls = cls + " half" if ( abs.reason_id != abs.new_reason_id && abs.new_reason_id.to_i != 0 )
    cls
  end 

  def abs_class_td( abs )      
      cls = abs.reason_id == 1 ? "hot" : ""
      cls += ' striked' if abs.canceled
      cls += ' nonactual' if (abs.try(:dt_from) < (-7.days.from_now)) || abs.canceled

      cls += " info" if ( abs.reason_id != abs.new_reason_id && abs.new_reason_id.to_i != 0 ) || 
                      ( abs.reason_id == 6 && !abs.approved)
      cls
  end

  def abs_description(a)
      tooltip_str_from_hash({ a.user_name => ' ', 
        'причина:' => a.reason_name, 
        'объект:'  => a.project_name, 
        'c  ' => a.dt_from.try('strftime',"%d.%m.%Y %H:%M"),
        'по'  => a.dt_to.try('strftime',"%d.%m.%Y %H:%M")
        })
  end

  def date_birth_li(day_births, day)
    dm = day.try('strftime','%d.%m')
    if day_births.keys.include? dm 
       content_tag :li, ['День рождения', '<br/>','<b>', day_births[dm], '</b>'].join.html_safe, 
        {class: 'birthday ', 'data-toggle' => "tooltip", 'data-placement' => "top", title: 'День рождения'}
    end

  end
end
