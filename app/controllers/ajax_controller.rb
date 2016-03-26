class AjaxController < ApplicationController

before_action :logged_in_user
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

  def add_comment
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
	      develop.dev_status_id = params[:checked]=='true' ? 3 : 4
        develop.save  
      else
        if [1,2,4].include?(develop.dev_status_id)
          develop.dev_status_id = params[:checked]=='true' ? 2 : 4
          develop.save  
        end
      end
      
   end
   render :nothing => true
  end

  def switch_check
      item = params[:model].classify.constantize.find(params[:item_id])
      if !item.nil?
          item[params[:field]] = params[:checked]
          item.save
      end
      render :nothing => true 
  end

  def upd_param
  	if params['model'] && params['model']!='undefined'

  		obj = Object.const_get(params['model']).find(params['id'])
      params[:upd].each do |p|
        #p "p",p,obj[p[0]]
        new_value = p[1]
        new_value.gsub!(' ','') if p[0]=='sum'  
        obj[p[0]] = new_value
      end
      obj.save
   	 end
   	 render :nothing => true 
   	end

end
