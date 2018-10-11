module UsersHelper

  def user_option(id)
    f = @user.options.find_by_option_id(id) #where(:option_id => id)
    f.nil? ? false : f.value
  end

  def class_for_user(user)
    "nonactual" if user.fired
  end

  def date_of_birth(user)
      

      if user.date_birth
         a = content_tag("span",user.date_birth.strftime("%d.%m.%Y"))

        today = Date.today()         
        today.change(year: user.date_birth.year)
        diff = (Date.parse(user.date_birth.to_s)- today).to_i 
        diff=diff-1
       
        case diff
        when -1
          txt = "сегодня!!!"
        when 0
          txt = "завтра!"
        when 1
          txt = "послезавтра!"  
        when 2..4
          txt = "через #{diff} дня"
        else
          txt = "через #{diff} дней"
        end
              

         if diff <8 && diff >=-1 
            d = content_tag :span,txt
            e = content_tag("span","",{:class=>'icon icon_birthday'})
            c = content_tag :span, {:class => 'red message'} do
              d + e
            end
            a  + c
          else
            a
         end 
      end
  end

end
