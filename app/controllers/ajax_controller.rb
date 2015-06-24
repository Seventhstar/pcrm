class AjaxController < ApplicationController

  def channels
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      channels = Channel.where("name like ? ", like)
    else
      channels = Channel.all
    end
    list = channels.map {|u| Hash[ id: u.id, label: u.name, name: u.name]}
    render json: list
  end

  def leads
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      leads = Lead.where("name like ? ", like)
    else
      leads = Lead.all
    end
    list = leads.map {|u| Hash[ id: u.id, label: u.name, name: u.name]}
    render json: list
  end

  def add_provider_manager
   if params[:provider_id] 
      pm = ProviderManager.new
      pm.provider_id = params[:provider_id] 
      pm.name  = params[:manager][:name]
      pm.phone = params[:manager][:phone]
      pm.email = params[:manager][:email]
      pm.save  
   end
   render :nothing => true 
  end

  def del_provider_manager
     if params[:p_id] 
      pm = ProviderManager.find(params[:p_id]).destroy
     end
    render :nothing => true
  end

  def add_comment
   #if params[:lead_id] 
   ##   leadcomment = LeadsComment.new
   #   leadcomment.lead_id = params[:lead_id]
   #   leadcomment.comment = params[:comment]
   #   leadcomment.user_id = current_user.id
   #   leadcomment.save	
   #end

   if params[:owner_id]
     com = Comment.new
     com.comment = params[:comment]
     com.user_id = current_user.id
     com.owner_id = params[:owner_id]
     com.owner_type= params[:owner_type]
     com.save
   end
	 render :nothing => true
  end

  def del_comment
   if params[:comment_id] 
      leadcomment = Comment.find(params[:comment_id]).destroy
   end
  	render :nothing => true
   end

  def dev_check
   if params[:develop_id]
      develop = Develop.find(params[:develop_id])
      if params[:field] == "boss"
        #develop.boss = params[:checked]
        
	      develop.dev_status_id = params[:checked]=='true' ? 3 : 4
        #puts develop.dev_status_id
        develop.save  
      else
        #develop.coder = params[:checked]
        #puts "develop.dev_status_id: "+develop.dev_status_id.to_s
        if [1,2,4].include?(develop.dev_status_id)
          develop.dev_status_id = params[:checked]=='true' ? 2 : 4
          develop.save  
        end
      end
      
   end
   render :nothing => true
  end

  def status_check
   if params[:status_id]
      develop = Status.find(params[:status_id])
      develop.actual = params[:checked]
      develop.save  
   end
   render :nothing => true
  end


  def user_upd
   if params[:user_id]
      u = User.find(params[:user_id])
      if params[:field] == "admin"
        u.admin = params[:checked]
      else
        u.activated = params[:checked]
      end
      u.save  
   end
   render :nothing => true
  end

  def upd_param
  	if params['model'] && params['model']!='undefined'
  		#puts params        
  		obj = Object.const_get(params['model']).find(params['id'])
   	 	#puts obj.class
   	 	new_name = params['upd']['name'].present? ? params['upd']['name'] : params['upd']['undefined']
      #puts "obj.name: " + obj.name+ ", new_name: " + new_name + "obj.name.to_s != new_name: " + (obj.name.to_s != new_name).to_s
   	 	if obj.name != new_name
   	 		obj.name  = new_name
   	 		obj.save
   	 	end

   	 end
   	 render :nothing => true
   	end

end
