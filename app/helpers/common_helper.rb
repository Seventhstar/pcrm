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
      v = obj.versions.last
      author = find_version_author_name(version) 
      at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      changeset = version.changeset 
      if v.event = "create"
        event = "создал задачу"
      elsif v.event = "update"
        event = "создал задачу"

      end


  end

  def get_history_with_files(lead)
    history = Hash.new
    # изменения в самом объекте
    lead.versions.reverse.each do |version|
      if version[:event]!="create" && version != lead.versions.first 
        author = find_version_author_name(version) 
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        changeset = version.changeset 
        ch = Hash.new
        desc = []
        changeset.keys.each_with_index do |k,index| 
          
          from_to = from_to_from_changeset(changeset[k],k)
          from = from_to['from'] 
          to = from_to['to']
          if from.present? || to.present?
            puts 'Изменено поле <b>'+t(k)+'</b> c «'
            desc << (from==nil ? to : ('Изменено поле <b>'+t(k)+'</b> c «'+from.to_s+'» на «'+to.to_s+'»') )
            ch.store( index, {'field' => t(k), 'from' => from, 'to' => to, 'description' => desc } )
          end
        end

        
        #changeset.each do |fields|
         # k = fields[1]
          #desc << ('Изменено поле <b>'+k['field'] +'</b> c «'+k['from'] +'» на «'+ k['to']+'»')
         # desc << 'Изменено поле <b>'
        #end

        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch, 'description' => desc})
      end
    end
    # созданные файлы
    lead.files.each do |file|
      ch = Hash.new
      file.versions.reverse.each do |version|
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        author = user_name(version.whodunnit)
        ch.store( index, {'file' =>  file.name} )
        desc = []
        desc << ('Добавлен файл <b>'+file.name+'</b>')
        history.store( at, {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch,'description' => desc})
      end  
    end
    # удаленные файлы
    file_id = []
    deleted = PaperTrail::Version.where_object(''+controller_name[0..-2]+'_id' => lead.id)
    deleted << PaperTrail::Version.where_object(''+controller_name[0..-2]+'_id' => "'"+lead.id.to_s+"'")
    #deleted = PaperTrail::Version.where_object(lead_id: lead.id)
    deleted.each_with_index do |file,index|
      ch = Hash.new  
      puts "file!!!"
      puts "file:"+file.to_s
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      author = user_name(file.whodunnit)
      file_id << file['item_id']
      f = file['object'].split(/\r?\n/)
      f.shift
      a = Hash.new
      f.each do |line| 
        b,c = line.chomp.split(/: /)
        a[b] = c
      end
      #at = a['created_at'].to_time.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      desc = []
      desc << 'Удален файл <b>' +a['name'] +'</b>'

      ch.store( index, {'file' =>  a['name']} )
      history.store( at, {'at' => at_hum,'type'=> 'del','author' => author,'changeset' => ch,'description' => desc})
    end  
    
    # созданные и потом удаленные файлы
    created = PaperTrail::Version.where(:item_id => file_id, event: 'create', item_type: 'LeadsFile')
    created.each_with_index do |file,index|
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      ch = Hash.new  
      author = user_name(file.whodunnit)
      file_id << file['item_id']
      f = file['object_changes'].split(/\r?\n/)
      ch.store( index, {'file' =>  f[f.index('name:')+2][2..-1] } )
      desc = []
      desc << 'Добавлен файл <b>' +f[f.index('name:')+2][2..-1] +'</b>'
      history.store( at, {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch,'description' => desc})
    end  
    history.sort.reverse
  end


end