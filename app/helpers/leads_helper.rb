module LeadsHelper
 def find_version_author_name(version)
    user = User.find_version_author(version) 
    user ? user.name : ''
 end

 def channel_name(ch_id)
    if ch_id.present?
       channel=Channel.find(ch_id)
       channel.name 
    else 
      res = ""
    end
 end

 def status_name(st_id)
   	if st_id.present?
   		status = Status.find(st_id)
   		status.name
   	else
   	res =""	
   	end
 end 

 def leads_page_url
    session[:last_leads_page] || leads_url
 end
 
 def store_leads_path
    session[:last_leads_page] = request.url || leads_url if request.get?
 end


end
