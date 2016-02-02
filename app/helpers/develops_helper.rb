module DevelopsHelper

  def show_dev
    show = params[:show]
    %w[check new all].include?(show) ? show : "check" 
  end

  def switch_active(show)
    active = show == show_dev ? "active" : nil
    css_class = "btn #{active}" 
  end

 def project_name(dev_id)
    if dev_id.present?
       dev = Develop.find(dev_id)
       if dev.project_id.present? && !dev.project.nil?
          dev.project.name
       else
          "Без проекта"
       end
    else 
      res = "Без проекта"
    end
 end

  def priority_name(priority_id)
 	  if priority_id.present?
       Priority.find_by_id(priority_id).try(:name)
   	else
   	  ""	
   	end
  end


 def status_name(st_id)
   	if st_id.present?
       DevStatus.find_by_id(st_id).try(:name)
   	else
   	  ""	
   	end
 end 



end
