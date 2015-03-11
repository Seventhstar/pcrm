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


  def add_comment
   if params[:lead_id] 
      leadcomment = LeadsComment.new
      leadcomment.lead_id = params[:lead_id]
      leadcomment.comment = params[:comment]
      leadcomment.user_id = current_user.id
      leadcomment.save	
   end
	render :nothing => true
   end

  def del_comment
   if params[:lead_comment_id] 
      leadcomment = LeadsComment.find(params[:lead_comment_id]).destroy
   end
  	render :nothing => true
   end

   def del_file
     if params[:file_id]
        file = LeadsFile.find(params[:file_id])
        filename = Rails.root.join('public', 'uploads','leads',file.lead.id.to_s,file.name)
        File.delete(filename) if File.exist?(filename)
        file.destroy
     end
     render :nothing => true
   end


  def dev_check
   if params[:develop_id]
      develop = Develop.find(params[:develop_id])
      if params[:field] == "boss"
        develop.boss = params[:checked]
      else
        develop.coder = params[:checked]
      end
      develop.save  
   end
   render :nothing => true
  end

end
