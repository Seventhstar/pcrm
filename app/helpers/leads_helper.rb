module LeadsHelper

 def is_update_form?
     controller.action_name == 'edit_multiple'
 end

 def channel_name(ch_id)
    if ch_id.present?
       channel=Channel.find(ch_id)
       channel.name 
    else 
      ""
    end
 end

 def status_name(st_id)
   	if st_id.present?
       Status.find_by_id(st_id).try(:name)
   	else
   	  ""	
   	end
 end 



 def leads_page_url
#    flash[:warning]= edit_polymorphic_url(@lead)
#    flash[:info]= session[:last_leads_page]
    sess_url = session[:last_leads_page]
    sess_url || leads_url
 end
 
 def store_leads_path
    session[:last_leads_page] = request.url || leads_url if request.get?
 end

 def multi_edit_icon
    if current_user.admin? 
      link_to edit_multiple_leads_path, {:class => 'li-right splink'} do #splink
        image_tag('edit.png')
      end
    end
 end

end
