module CommonHelper

  def find_version_author_name(version)
    user = User.find_version_author(version).try(:name)
  end

  def user_name(id)
    if !id.nil? && id&.to_i>0
     user = User.find(id).try(:name)
    else
      ""
    end
  end

  def is_manager?
    current_user.has_role?(:manager)
  end

  def month_year(date)
    "#{t date.try('strftime','%B')} #{date.try('strftime','%Y')}"
  end

  def check_new_table_head(obj, field = nil)
    if field.nil? 
      case params[:sort]
      when "users.name"
        new_head = head_name(obj,'user_id')
      when "ic_users.name"
        new_head = head_name(obj,'ic_user_id')
      when "status_id","pstatus_id","start_date", "status_date", "project_id",
           "executor_id", "project_type_id", "provider_id","project_g_type_id"
        new_head = head_name(obj,params[:sort])
      else
        case obj.class.name
        when "Lead"
          new_head = is_admin? ? head_name(obj, 'status_date') : head_name(obj, 'start_date') 
        when "Costing"
          new_head = head_name(obj, 'user_id')
        when "ProjectGood"
          prm = params[:sort]
          prm = 'project_id' if prm.nil?
          new_head = head_name(obj, prm)
        else
          new_head = nil
        end
      end
    else
      new_head = head_name(obj, field)
    end

    need_head = false
    if @cur_head != new_head 
      @cur_head = new_head
      need_head = true
    end
    need_head
  end

  def text_or_link(text, link)
    link ? link_to(text, [:edit, link]) : text
  end

  def head_name(obj, id_name)
    id = obj[id_name]
    
    case id_name
    when 'executor_id', 'ic_user_id', 'user_id'
      val = User.find(id).try(:name) if id.present? 
    when 'start_date','status_date'
      val = month_year(id)
    when :goodstype_id
      val = obj.try(:goodstype).try(:name)
    when 'project_id'
      val = 'Не все данные заполнены'
      val = obj.try(:project).try(:address)
      id  = obj.try(:project).try(:id)
    else
      prop_name = "#{id_name[0..-4]}_name"
      val = obj.try(prop_name)
    end

    n = (id.nil? || id==0) ? t("without.#{id_name}") : val
    n
  end


  def from_to_from_changeset(obj,changeset,event)
    
    from = ""  
    to = ""

    case event 
    when "updated_at"
    when "verified", "payd_q", "attention", "debt", "interest", "payd_full", "secret", 'order'
      from = changeset[0] ? 'Да' : 'Нет'
      to =  changeset[1] ? 'Да' : 'Нет'
    when "coder", "boss"
      from = nil
      pref = changeset[1]? '': ' не '
      status = event == "coder" ? "выполнено" : "проверено"  
      to = "Помечен как <b>#{pref} #{status}</b>"
    when 'dt_to', 'dt_from'
      from = changeset[0].try('strftime',"%Y.%m.%d %H:%M" )
      to   = changeset[1].try('strftime',"%Y.%m.%d %H:%M" )

    when "channel_id", 'reason_id','new_reason_id','target_id','dev_status_id',
         'status_id','p_status_id', 'priority_id', 'project_id',"user_id","ic_user_id",
         "executor_id","pstatus_id", "project_type_id", 'payment_purpose_id', 
         'payment_type_id', 'source_id', 'city_id', 'delivery_time_id', 'currency_id',
         'goods_priority_id'

      attrib = event.gsub('_id','').gsub('new_','')
      cls = obj["item_type"].constantize.find_by_id(obj["item_id"])
      if !cls.nil?
        cls = cls.try(attrib).class
        if !cls.nil? && cls != NilClass
          from = cls.where(id: changeset[0]).first_or_initialize.try(:name) if !changeset[0].nil? && changeset[0]!=0
          to = cls.where(id: changeset[1]).first_or_initialize.try(:name) if !changeset[1].nil? && changeset[1]!=0
        end
      else
        from = changeset[0]
        to = changeset[1]
      end
    else

      from = changeset[0]
      to = changeset[1]
    end
    {from: from, to: to }
  end

  def get_last_history_item(obj)
    history = Hash.new
    # изменения в самом объекте
    version = obj.versions.last || @version
    author = find_version_author_name(version) 
    at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
    at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
    changeset = version.changeset 
    ch = Hash.new
    desc = []
    changeset.keys.each_with_index do |k,index| 
      from_to = from_to_from_changeset(version, changeset[k], k)
      from = from_to[:from] 
      to = from_to[:to]
      
      if from.present? || to.present?
        from = from.nil? ? "" : from.to_s
        to = to.nil?  ? "" : to.to_s
        filled = "Заполнено поле <b>'#{t(k)}:</b> «#{to}»"
        if k == 'description' || k == 'info'
          from.gsub!(/\n/, '<br>')  
          to.gsub!(/\n/, '<br>')
        else
          # desc << (from.empty? ? filled : ('Изменено поле <b>'+t(k)+'</b> c «'+from+'» на «'+to+'»') )
        end
        
        desc << (from.empty? ? filled : ('Изменено поле <b>'+t(k)+'</b>: c <br>«'+from+'»<br><b> на </b><br>«'+to+'»') )
        ch.store( index, {field: t(k), from: from, to: to, description: desc } )
      end
    end

    history.store( at.to_s, {at: at_hum, type: 'ch', author: author, changeset: ch, description: desc})
     # end
    history
  end

  def link_to_obj(obj, id)
    _obj = obj.nil? ? '' : obj.tableize
    obj_name = obj.present? ? t(obj) : ''
    "<a href=#{[_obj, id, 'edit'].join('/')}>#{obj_name} ##{id}</a>"
  end

  def link_to_file(obj)
    name = obj['name'][1]
    id   = obj['owner_id'][1]
    ext  = name.split('.')[1]
    type = obj['owner_type'][1]
    filename = "#{obj['id'][1]}.#{ext}"
    full_path = Rails.root.join('public', 'uploads', type, id.to_s, filename)
    data_modal = ['jpg','gif','png'].include?(ext) ?  "data-modal='true'" : ''
    if File.exists?(full_path)
      # "<a href=#{['files', obj['id'][1]].join('/')} #{data_modal}>#{name}</a>"
      file_default_action(obj['id'][1],'',false)
    else
      "<span class='striked'>#{name}</span>"
    end
  end

  def changeset_detail(version)
    obj = YAML.load(version['object_changes']) if !version['object_changes'].nil?
    obj = YAML.load(version['object']) if obj.nil?
    lnk = link_to_obj(version["item_type"], version['item_id'])
    info = {}
    ch = {}
    case version[:event]
    when "update" 
        changeset = version.changeset 
        desc = []
        changeset.keys.each_with_index do |k,index| 
          from_to = from_to_from_changeset(version,changeset[k],k)
          from = from_to[:from] 
          to = from_to[:to]
          if from.present? || to.present?
            from = from.nil? ? "" : from.to_s
            k = 'pdate' if k=='date'

            desc << (from.empty? || from==to ? "Заполнено поле <b>#{t(k)}:</b> «#{to}»" : 
                                               "Изменено поле <b>#{t(k)}</b> c «#{from}» на «#{to}»" )
            ch.store( index, {field: t(k), from: from, to: to, description: desc } )
          end
        end
    when "create"
        case version['item_type']
        when 'Attachment' 
          lnk = link_to_obj(obj['owner_type'][1], obj['owner_id'][1])
          desc = "Прикреплен файл #{link_to_file(obj)} к объекту: #{lnk}"
        when 'Develop'
          desc = "Создана #{lnk}"
        when 'Absence'
          desc = "Создано #{lnk}"
        else
          desc = "Создан #{lnk}"
        end
    when "destroy"    
      ch.store(0,'Удален')
      file = YAML.load(version['object'])
      
      if version['item_type'] == 'ProjectGood'
        lnk = link_to_obj('Project', file['project_id'])
        desc = "Удален заказ в #{lnk} [#{file['name']} на сумму #{file['gsum']}]"
      elsif file['owner_type'].nil?
        desc = "Удален объект: #{t(version['item_type'])} ##{version['item_id']} [#{version['object']}]"
      else
        desc = "Удален файл #{file['name']} у объекта: #{link_to_obj(file['owner_type'], file['owner_id'])}"
      end 
    else
      desc = {"version[:event]"=> version[:event]}
    end
    obj['inf'] = {ch: ch, desc: desc}
    obj
  end

  def get_version_details(version)
    info = changeset_detail(version)
  end

  def get_history_with_files(obj)
    history = Hash.new
    # изменения в самом объекте
    obj.versions.reverse.each do |version|
      if version[:event]!="create" && version != obj.versions.first 
        created = version.created_at.localtime
        at = created.strftime("%Y.%m.%d %H:%M:%S")         
        info = changeset_detail(version)['inf']
        history.store( at.to_s, {at: created.strftime("%d.%m.%Y %H:%M:%S"), 
                                  type: 'ch', 
                                  author: find_version_author_name(version), 
                                  changeset: info[:ch], 
                                  description: info[:desc]})
      end
    end
   
    created = PaperTrail::Version.where_object_changes(owner_id: obj.id, owner_type: obj.class.name)
    created.each_with_index do |file, index|
      file_changes(history, file, index, 'object_changes', 'add', 'Добавлен', '1')
    end  

    # удаленные файлы
    file_id = []
    deleted = PaperTrail::Version.where_object(owner_id: obj.id, owner_type: obj.class.name)
    deleted = PaperTrail::Version.where_object(owner_id: "'#{obj.id}'", owner_type: obj.class.name) if deleted.count==0
    deleted.each_with_index do |file, index|
      file_id << file['item_id']
      file_changes(history, file, index, 'object', 'del', 'Удален', '2')
    end  

    # созданные и потом удаленные файлы
    created = PaperTrail::Version.where(item_id: file_id, event: 'create', item_type: controller_name.classify+'sFile')
    created.each_with_index do |file, index|
      file_changes(history, file, index, 'object_changes', 'add', 'Добавлен', '1')
    end  
    history.sort.reverse
  end

  def file_changes(history, file, index, fields, type, type_t, order)
    obj = YAML.load(file[fields])
    fname = type == 'del' ? obj['name'] : obj['name'][1]
    created = file.created_at.localtime
    at      = created.strftime("%Y.%m.%d %H:%M:%S") 
    history.store( at+order, {at: created.strftime("%d.%m.%Y %H:%M:%S"), 
                              type: type, 
                              author: user_name(file.whodunnit), 
                              changeset: {'index' => {file: fname}}, 
                              description: ["#{type_t} файл <b>#{fname}</b>"]})
  end

end