module CommonHelper

 def find_version_author_name(version)
    user = User.find_version_author(version) 
    user ? user.name : ''
 end

  def user_name(id)
    if !id.nil? && id!=0
     user = User.find(id)
     user ? user.name : ''
    else
      ""
    end
    
  end

  def from_to_from_changeset(changeset,event)
      to=""
    case event 
    when "updated_at"
    when "coder"
      from = nil
      pref = changeset[1]? '': ' не '
      to = 'Помечен как <b>' + pref + ' выполнено </b>'
    when "boss"
      from = nil
      pref = changeset[1]? '': ' не '
      to = 'Помечен как <b>' + pref + ' проверено </b>'
    when "channel_id"
      from = channel_name(changeset[0])
      to = channel_name(changeset[1]) 
    when "dev_status_id"
      from = status_name(changeset[0])
      to = status_name(changeset[1])      
    when "status_id"
      from = status_name(changeset[0])
      to = status_name(changeset[1])
    when "priority_id"
      from = priority_name(changeset[0])
      to = priority_name(changeset[1]) 
    when "project_id"
      from = project_name(changeset[0])
      to = project_name(changeset[1]) 
    when "user_id","ic_user_id"
      from = user_name(changeset[0])
      to = user_name(changeset[1]) 
    else
      from = changeset[0]
      to = changeset[1]
    end
    {'from' => from, 'to' => to }
  end

  def get_last_history_item(obj)
      history = Hash.new
    # изменения в самом объекте
      version = obj.versions.last || @version
      #if version[:event]!="create" && version != obj.versions.first 
        author = find_version_author_name(version) 
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        changeset = version.changeset 
        #puts "changeset: "+changeset
        ch = Hash.new
        desc = []
        changeset.keys.each_with_index do |k,index| 
          
          from_to = from_to_from_changeset(changeset[k],k)
          from = from_to['from'] 
          to = from_to['to']
          if from.present? || to.present?
            from = from.nil? ? "" : from.to_s
            to = to.nil?  ? "" : to.to_s
          	#puts k,k == 'description'
          	if k == 'description' || k == 'info'
          	  
          	  from.gsub!(/\n/, '<br>')
          	  
          	  to.gsub!(/\n/, '<br>')
              desc << (from.empty? ? ('Заполнено поле <b>'+t(k)+':</b> «'+to+'»') : ('Изменено поле <b>'+t(k)+'</b> c<br> «'+from+'»<br><b> на </b><br>«'+to+'»') )
            else
              desc << (from.empty? ?  ('Заполнено поле <b>'+t(k)+':</b> «'+to+'»'): ('Изменено поле <b>'+t(k)+'</b> c «'+from+'» на «'+to+'»') )
        	end
            ch.store( index, {'field' => t(k), 'from' => from, 'to' => to, 'description' => desc } )
          end
        end

        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch, 'description' => desc})
     # end
    history
  end

  def get_all_history
    pt = PaperTrail::Version.order(created_at: :desc).limit(50) #.where('created_at > ?',Date.yesterday)
  end

  def link_to_obj(obj, id)
    "<a href=" + [nil,obj.downcase.pluralize,id,'edit'].join('/')+ ">" + t(obj) +' #' + id.to_s + "</a>"
  end

  def changeset_detail(version)
    obj = YAML.load(version['object_changes'])
    obj = YAML.load(version['object']) if obj.nil?
    info = {}
    case version[:event]
    when "update" 
        changeset = version.changeset 
        ch = Hash.new
        desc = []
        changeset.keys.each_with_index do |k,index| 
          
          from_to = from_to_from_changeset(changeset[k],k)
          from = from_to['from'] 
          to = from_to['to']
          if from.present? || to.present?
            from = from.nil? ? "" : from.to_s
            desc << (from.empty? ? ('Заполнено поле <b>'+t(k)+':</b> «'+to.to_s+'»') : ('Изменено поле <b>'+t(k)+'</b> c «'+from.to_s+'» на «'+to.to_s+'»') )
            ch.store( index, {'field' => t(k), 'from' => from, 'to' => to, 'description' => desc } )
          end
        end
    when "create"
        ch = {}
        case version['item_type']
        when 'Attachment'
          desc = 'Прикреплен файл '+obj['name'][1]
        when 'Develop'
          desc = 'Создана ' +link_to_obj(version["item_type"], version['item_id'])
        else
          desc = 'Создан ' + link_to_obj(version["item_type"], version['item_id'])
        end
    else
      ch = {}
      desc = {}
    end
    {'ch' => ch, 'desc' => desc}
  end

  def get_version_details(version)
    obj = YAML.load(version['object_changes'])
    obj = YAML.load(version['object']) if obj.nil?
    p version
    # if version['item_type'] == 'Attachment'
    #   info = {:desc => 'Прикреплен файл '+obj['name'][1]}
    # else
       info = changeset_detail(version)
    # end
    obj['inf'] = info

    obj
    
  end

  def get_history_with_files(obj)
    history = Hash.new
    # изменения в самом объекте
    obj.versions.reverse.each do |version|
      if version[:event]!="create" && version != obj.versions.first 
        author = find_version_author_name(version) 
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        info = changeset_detail(version)

        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => info['ch'], 'description' => info['desc']})
      end
    end
   
    created = PaperTrail::Version.where_object_changes(owner_id: obj.id, owner_type: obj.class.name)

    created.each_with_index do |file,index|
      ch = Hash.new  
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      author = user_name(file.whodunnit)
      _obj = YAML.load(file['object_changes'])
      desc = []
      desc << 'Cоздан файл файл <b>' +_obj['name'][1] +'</b>'

      ch.store( index, {'file' =>  _obj['name'][1]} )
      history.store( at+'2', {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch,'description' => desc})
    end  

    # удаленные файлы
    file_id = []
    deleted = PaperTrail::Version.where_object(owner_id: obj.id, owner_type: obj.class.name)

    if deleted.count==0
        deleted = PaperTrail::Version.where_object(owner_id: "'"+obj.id.to_s+"'", owner_type: obj.class.name)
    end

    deleted.each_with_index do |file,index|
      ch = Hash.new  
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      author = user_name(file.whodunnit)
      file_id << file['item_id']

      _obj = YAML.load(file['object'])
      desc = []
      desc << 'Удален файл <b>' +_obj['name'] +'</b>'

      ch.store( index, {'file' =>  _obj['name']} )
      history.store( at+'2', {'at' => at_hum,'type'=> 'del','author' => author,'changeset' => ch,'description' => desc})
    end  
    # созданные и потом удаленные файлы
    created = PaperTrail::Version.where(:item_id => file_id, event: 'create', item_type: controller_name.classify+'sFile')
    created.each_with_index do |file,index|

      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      ch = Hash.new  
      author = user_name(file.whodunnit)
      file_id << file['item_id']
      obj = YAML.load(file['object_changes'])
      ch.store( index, {'file' =>  obj['name'][1] } )
      desc = []
      desc << 'Добавлен файл <b>' +obj['name'][1] +'</b>'
      history.store( at +'1', {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch,'description' => desc})
    end  
    history.sort.reverse
  end


end