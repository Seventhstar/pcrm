class AjaxController < ApplicationController
  before_action :logged_in_user

  def update_holidays
    # if params[:year]
    y = Date.today.year.to_s
    url = "http://xmlcalendar.ru/data/ru/"+y+"/calendar.xml"
    xml = Nokogiri::XML(open(url))

    xml.xpath('//days/day').each do |d|
      dt = d.attr('d')
      h  = d.attr('h')
      hn = xml.xpath('//holidays/holiday[@id='+h+']').attr('title').value if !h.nil?
      p [dt,h,hn]
      day = Date.parse(y+'.'+dt)
      dd = Holiday.find_by_day(day)
      if dd.nil? 
        new_d = Holiday.new
        new_d.day = day
        new_d.name = hn 
        new_d.save
      end
    end
    render :nothing => true
  end

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
      com.owner_type = params[:owner_type]
      com.save
      admins = User.where(admin: true).ids # помечаем сообщения непрочитанными
      admins.delete(current_user.id) # кроме себя
      admins.each do |a|
        cu = CommentUnread.new
        cu.user_id = a
        cu.comment_id = com.id
        cu.save
      end

   end
	 render :nothing => true
  end

  def del_comment
   if params[:comment_id] 
      leadcomment = Comment.find(params[:comment_id]).destroy
   end
  	render :nothing => true
   end

  def read_comment
    if params[:comment_id]
      c = CommentUnread.where(comment_id: params[:comment_id], user_id: current_user.id)
      # p "c.count",c.count
      if c.count >0
        c.destroy_all
      else
        c = CommentUnread.new
        c.comment_id = params[:comment_id]
        c.user_id = current_user.id
        c.save 
      end
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
    # p "params[:model]",params[:model]
    if params[:model]
      item = params[:model].classify.constantize.find(params[:item_id])
      if !item.nil?
          item[params[:field]] = params[:checked]
          item.save
      end
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
        obj[p[0]] = new_value if p[0]!='undefined'
      end
      obj.save
   	 end
   	 render :nothing => true 
   	end

end
