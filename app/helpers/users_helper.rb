module UsersHelper

  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end



  def date_of_birth(user)
      

      if user.date_birth
         a = content_tag("span",user.date_birth.strftime("%d.%m.%Y"))

        today = Date.today()         
        today.change(year: user.date_birth.year)
        diff = (Date.parse(user.date_birth.to_s)- today).to_i 
        diff=diff-1
        #diff = diff/ (24 * 3600)
        
        #puts "diff"
        #puts diff
        #puts today
        #puts user.date_birth
        #puts Date.parse(user.date_birth.to_s)
        #s

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
