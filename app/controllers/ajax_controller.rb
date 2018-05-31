  class AjaxController < ApplicationController
  before_action :logged_in_user

  respond_to :js, :json 

  def autocomplete
    model = params[:model].classify
    name_field = model == 'Project' ? 'address' : 'name'

    if params[:term]
      projects = model.constantize.where("lower("+name_field+") like lower(?) ", "%#{params[:term]}%")
    else
      projects = model.constantize.first(10)
    end

    list = projects.map {|u| Hash[ id: u.id, label: u[name_field], name: u[name_field] ]}

    render json: list
  end


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
    head :ok
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
   head :ok
  end

  def del_comment
   if params[:comment_id] 
      leadcomment = Comment.find(params[:comment_id]).destroy
   end
    head :ok
  end

  def store_cut
      ls = session['last_'+params['cntr']+'_page']
      ls = url_for(action: 'index', controller: params['cntr'])
      # p params,ls
      url = URI.parse(ls) 
      url.query = params['cut'] #Rack::Utils.parse_nested_query(url.query).merge({cut: params['cut']}).to_query  
      # p url.to_s
      session["last_"+params['cntr']+"_page"] = url.to_s
      # p session["last_"+params['cntr']+"_page"]

      head :ok
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
    head :ok
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
   head :ok
  end

  def switch_check
    # p "params[:model]",params[:model]
    if params[:model] == 'UserRole'
      item = UserRole.where(user_id: params[:item_id], role_id: params[:field])
      if params[:checked] == 'true'
         item = UserRole.new
         item.user_id = params[:item_id]
         item.role_id = params[:field]
         item.save
      else
        item.destroy_all
      end

    elsif params[:model]
      item = params[:model].classify.constantize.find(params[:item_id])
      if !item.nil?
          item[params[:field]] = params[:checked]
          item.save
      end
    end
    head :ok
  end

  def switch_locked
    if current_user.has_role?(:manager)
    puts "current_user #{current_user.name} #{current_user.has_role?(:manager)}" 
      file = Attachment.find(params[:file])
      file.update_attribute(:secret,!file.secret)
      head :ok
    else
      head :error
    end
    # render nothing: true
  end

  def upd_param
    if params['model'] && params['model']!='undefined'

      obj = Object.const_get(params['model']).find(params['id'])
      prms = params[:upd]
      prms = params['upd'+params[:id]] if prms.nil?
      prms = params['upd_modal'] if prms.nil?

      prms = prms.permit!.to_h
      prms.each do |p|
        new_value = p[1]
        new_value.gsub!(' ','') if !p[0].index('sum').nil?
        obj[p[0]] = new_value if p[0]!='undefined'
      end


      if !obj.save

        render html: obj.errors.full_messages, status: :unprocessable_entity
      else
        # p "obj.errors.full_messages #{obj.errors.full_messages}"
        # respond_to do |format|
        # # msg = "Успешно обновлено: "+ t(obj.class.name)
        # end
        msg = "Успешно обновлено: "+ t(obj.class.name)
        render json: msg.to_json, status: :ok
        #p "obj: #{obj}"
        # respond_to do |format|
        #   format.js { render location: params[:model].tableize+'#update' }
        #   # respond_with(obj, location: )
        # end
      end
     else
      # render json: nil, status: :ok
     end
     # render :nothing => true 
     
    end

end
