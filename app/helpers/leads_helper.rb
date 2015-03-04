module LeadsHelper
 def find_version_author_name(version)
    user = User.find_version_author(version) 
    user ? user.name : ''
 end

 def channel_name(ch_id)
    if ch_id?
       channel=Channel.find(ch_id)
       channel.name 
    else 
      res = ""
    end
 end

 def status_name(st_id)
   	if st_id?
   		status = Status.find(st_id)
   		status.name
   	else
   	res =""	
   	end
 end 

end
