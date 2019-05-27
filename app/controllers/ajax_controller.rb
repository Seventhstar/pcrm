class AjaxController < ApplicationController
  before_action :logged_in_user
  respond_to :js, :json 
  skip_before_action :verify_authenticity_token, only: [:add_work]

  def set_work_params(wrk, wrk_params)
    wrk.step        = wrk_params[:step]
    wrk.costing_id  = wrk_params[:costing_id]
    wrk.work_id     = wrk_params[:work_id]
    wrk.room_id     = wrk_params[:room][:room_id]

    wrk.room_id     = wrk_params[:room][:value] if wrk.room_id.nil?

    # puts "wrk_params[:costing_id] #{wrk_params[:costing_id]}"

    wrk.price   = wrk_params[:price]
    wrk.qty     = wrk_params[:qty]
    wrk.amount  = wrk_params[:amount]

  end

  def upd_work
    wrk = CostingWork.find(wrk_params[:id])
    set_work_params(wrk, wrk_params)
    if wrk.save 
      @wrk = wrk
      # head :ok
      respond_with @wrk
    else
      # body wrk.errors.full_messages
      # head :unprocessable_entity
      respond_to do |format|
        format.json { render json: wrk.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def add_work
    prm = wrk_params
    # puts "prm #{prm}"
    wrk = CostingWork.new
    set_work_params(wrk, wrk_params)
    if wrk.save 
      head :ok
    else
      # body wrk.errors.full_messages
      # head :unprocessable_entity
      respond_to do |format|
        format.json { render json: wrk.errors.full_messages, status: :unprocessable_entity }
      end
    end
    # puts "errors: #{wrk.errors.full_messages}"
    # render json: params
    # head :ok
  end

  def wrk_params
    params.require(:ajax).permit!
  end

  def autocomplete

    if params[:model] == 'Option'
      # menu = get_menu()
      list = []
      menu = t('options_menu')
      # puts "menu: #{menu}"
      menu.each do |m0|
        # puts "m0: #{m0}"
        m0[1].each do |m1|
          m2_name = t(m1)[0]
          if m2_name.downcase.include?(params[:term].downcase)
            # puts "m1: #{m1}, m2_name: #{m2_name}"
            list << {id: m1, label: m2_name, name: 'options'}
          end

        end
      end
      render json: list
      return
    end

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

  def set_city
    @main_city = City.find(params[:city]) if params[:city]
    current_user.update_attribute('city', @main_city) if @main_city.present?
  end

  def update_holidays
    y = Date.today.year.to_s
    url = "http://xmlcalendar.ru/data/ru/#{y}/calendar.xml"
    xml = Nokogiri::XML(open(url))

    xml.xpath('//days/day').each do |d|
      dt = d.attr('d')
      h  = d.attr('h')
      if d.attr('t') == '1' # 1 - праздник, 2 - сокращенный день
        holiday_name = xml.xpath("//holidays/holiday[@id=#{h}]").attr('title').value if !h.nil?
        day = Date.parse(y+'.'+dt)
        Holiday.create({day: day, name: holiday_name}) if !Holiday.find_by_day(day)
      end
    end
    head :ok
  end

  def channels
    if params[:term]
      like = "%".concat(params[:term].concat("%"))
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
    url = URI.parse(ls) 
    url.query = params['cut']   
    session["last_"+params['cntr']+"_page"] = url.to_s

    head :ok
  end

  def read_comment
    if params[:comment_id]
      c = CommentUnread.where(comment_id: params[:comment_id], user_id: current_user.id)
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
  end

  def upd_param
    if params['model'] && params['model']!='undefined' && params['id'].present?

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
        msg = "Успешно обновлено: "+ t(obj.class.name)
        render json: msg.to_json, status: :ok
      end
    else
    end
  end

end
