module CommonHelper
  include DatesHelper

  def find_version_author_name(version)
    user = User.find_version_author(version).try(:name)
  end

  def clean_params
    params.delete_if{|k,v| v=='' || v=='0' }
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


  def from_to_from_changeset(obj, changeset, event)
    
    from = ""  
    to = ""

    case event 
    when "updated_at"
    when "verified", "payd_q", "attention", "debt", "interest", "payd_full", "secret", 'order', 'fixed'
      from  = changeset[0] ? 'Да' : 'Нет'
      to    = changeset[1] ? 'Да' : 'Нет'

    when "coder", "boss"
      from = nil
      pref = changeset[1]? '': ' не '
      status = event == "coder" ? "выполнено" : "проверено"  
      to = "Помечен как <b>#{pref} #{status}</b>"

    when 'dt_to', 'dt_from'
      from = format_datetime(changeset[0])
      to   = format_datetime(changeset[1])

    else 
      if event[-3,3] == '_id'
        attrib = event.gsub('_id','').gsub('new_','')

        if !attrib.nil? 
          cls_name = obj.item_type.classify.constantize.reflections[attrib]
          if cls_name != 'Owner' && !cls_name.nil? 
            cls_name = cls_name.class_name 
            cls = cls_name.constantize
            if !cls_name.nil? && cls != NilClass
              from = cls.find_or_create_by(id: changeset[0]).try(:name) if !changeset[0].nil? && changeset[0]!=0
              to   = cls.find_or_create_by(id: changeset[1]).try(:name) if !changeset[1].nil? && changeset[1]!=0
              from  = "[id = #{changeset[0]}]" if from.nil?
              to    = "[id = #{changeset[1]}]" if to.nil?
            end
          end
        else
          from = changeset[0]
          to = changeset[1]
        end
      else
        from = changeset[0]
        to = changeset[1]
      end
    end
    {from: from, to: to }
  end

  def get_last_history_item(obj)
    history = Hash.new
    # изменения в самом объекте
    version = obj.versions.last || @version
    author = find_version_author_name(version) 

    at      = format_dateseconds(version.created_at.localtime) 
    at_hum  = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
    
    changeset = version.changeset 
    ch = Hash.new
    desc = []
    # puts "get_history"
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
        ch.store(index, {field: t(k), from: from, to: to, description: desc } )
      end
    end

    history.store(at.to_s, {at: at_hum, type: 'ch', author: author, changeset: ch, description: desc})
     # end
    history
  end

  def link_to_obj(obj, id, name = nil)
    _obj = obj.nil? ? '' : obj.tableize
    obj_name = name
    obj_name = obj.present? ? t(obj) : '' if name.nil?
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
      file_default_action(obj['id'][1],'',false)
    else
      "<span class='striked'>#{name}</span>"
    end
  end

  def changeset_detail(version, internal = false)
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
          if obj['owner_id'].present? 
            lnk = link_to_obj(obj['owner_type'][1], obj['owner_id'][1]) 
            desc = "Прикреплен файл #{link_to_file(obj)} к объекту: #{lnk}" 
          else
            desc = ''
          end
        when 'ProjectGood'
          # lnk = link_to_obj('ProjectGood', obj['id'][1], "Заказ <b>#{obj['name'][1]}</b> на сумму #{obj['gsum'][1]}")
          desc = "Создан заказ <b>#{obj['name'][1]}</b> на сумму #{obj['gsum'][1].to_sum}"
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
        # puts "file['gsum'] #{file['gsum']} #{file['name']}"
        sum = file['gsum'].present? ? "на сумму #{file['gsum'].to_sum}]" : ''

        desc = "Удален заказ в #{lnk} [#{file['name']} #{sum}"
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
        history.store( at.to_s, { at: created.strftime("%d.%m.%Y %H:%M:%S"), 
                                  type: 'ch', 
                                  author: find_version_author_name(version), 
                                  changeset: info[:ch], 
                                  description: info[:desc]}) if info[:desc].present? 
      end
    end
   
    obj_id = obj.id

    updated_pg = PaperTrail::Version.where_object(project_id: obj.id, goods_priority_id: 1)
    # puts "updated_pg #{updated_pg} #{updated_pg.count}"
    updated_pg.each_with_index do |pg, index|
      created = pg.created_at.localtime
      at = created.strftime("%Y.%m.%d %H:%M:%S")         
      info = changeset_detail(pg)
      ch = info['inf']
        # gdg
        # puts "info #{info.class} #{info['id']} #{info}"
        # puts "pg #{pg} #{pg.item_type}"
        # puts "info desc #{info['desc']} #{info[:id]}"
        history.store( at.to_s, { at: created.strftime("%d.%m.%Y %H:%M:%S"), 
                                    type: 'ch_2', 
                                    author: find_version_author_name(pg), 
                                    changeset: '', 
                                    description: ch[:desc]}) if ch[:desc].present?
      # end
    end

    created = PaperTrail::Version.where_object_changes(owner_id: obj_id, owner_type: obj.class.name)
    created.each_with_index do |file, index|
      
      file_changes(history, file, index, 'object_changes', 'add', 'Добавлен', '1')
    end  

    # created = ProjectGood.versions.where(project_id: obj.id)
    created = PaperTrail::Version.where_object_changes(project_id: obj.id)
    # created.where(item_type: 'ProjectGood')
    created.each_with_index do |data, index|
      # puts "file #{file}: #{history}"
      changes = YAML.load(data['object_changes'])
      case data.item_type
      when 'Absence'
        info = changeset_detail(data, true)
        # hrr
      when 'ProjectGood'
        # puts "data #{data}"
        info = changeset_detail(data, true)
        # rr
      end

      localtime = data.created_at.localtime
      at = localtime.strftime("%Y.%m.%d %H:%M:%S")         
      time = localtime.strftime("%d.%m.%Y %H:%M:%S")         
      history.store( at.to_s, { at: time, 
                                    type: 'ch_2', 
                                    author: find_version_author_name(data), 
                                    changeset: '', 
                                    description: info['inf'][:desc]}) if info.present? && info['inf'][:desc].present?

      # file_changes(history, file, index, 'object_changes', 'add', 'Добавлен', '1')
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

  def abs_changes(history, file)
    obj = YAML.load(file[fields])
  end

  def file_changes(history, file, index, fields, type, type_t, order)
    obj = YAML.load(file[fields])
    fname = type == 'del' ? obj['name'] : obj['name'][1]
    created = file.created_at.localtime
    at      = created.strftime("%Y.%m.%d %H:%M:%S") 
    history.store( at + order, { at: created.strftime("%d.%m.%Y %H:%M:%S"), 
                                type: type, 
                                author: user_name(file.whodunnit), 
                                changeset: {'index' => {file: fname}}, 
                                description: ["#{type_t} файл <b>#{fname}</b>"]})
  end

end