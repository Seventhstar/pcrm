module DevelopsHelper

 def project_name(dev_id)
    if dev_id.present?
       dev = Develop.find(dev_id)
       if dev.project_id.present?
          dev.dev_project.name
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
