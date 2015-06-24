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
          	#puts k,k == 'description'
          	if k == 'description' || k == 'info'
          	  from.gsub!(/\n/, '<br>')
          	  to.gsub!(/\n/, '<br>')
              desc << ((from.nil? || from.empty?) ? ('Заполнено поле <b>'+t(k)+':</b> «'+to.to_s+'»') : ('Изменено поле <b>'+t(k)+'</b> c<br> «'+from.to_s+'»<br><b> на </b><br>«'+to.to_s+'»') )
            else
              desc << ((from.nil? || from.empty?) ?  ('Заполнено поле <b>'+t(k)+':</b> «'+to.to_s+'»'): ('Изменено поле <b>'+t(k)+'</b> c «'+from.to_s+'» на «'+to.to_s+'»') )
        	end
            ch.store( index, {'field' => t(k), 'from' => from, 'to' => to, 'description' => desc } )
          end
        end

        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch, 'description' => desc})
     # end
    history
  end

  def get_history_with_files(obj)
    history = Hash.new
    # изменения в самом объекте
    obj.versions.reverse.each do |version|
      if version[:event]!="create" && version != obj.versions.first 
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
            desc << ((from.nil? || from.empty?) ? ('Заполнено поле <b>'+t(k)+':</b> «'+to.to_s+'»') : ('Изменено поле <b>'+t(k)+'</b> c «'+from.to_s+'» на «'+to.to_s+'»') )
            ch.store( index, {'field' => t(k), 'from' => from, 'to' => to, 'description' => desc } )
          end
        end

        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch, 'description' => desc})
      end
    end
    # созданные файлы
    obj.files.each do |file|
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
    deleted = PaperTrail::Version.where_object(''+controller_name[0..-2]+'_id' => obj.id)

    if deleted.count==0
        deleted = PaperTrail::Version.where_object(''+controller_name[0..-2]+'_id' => "'"+obj.id.to_s+"'")
    end

    deleted.each_with_index do |file,index|
      ch = Hash.new  
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      author = user_name(file.whodunnit)
      file_id << file['item_id']

      obj = YAML.load(file['object'])
      desc = []
      desc << 'Удален файл <b>' +obj['name'] +'</b>'

      ch.store( index, {'file' =>  obj['name']} )
      history.store( at+'2', {'at' => at_hum,'type'=> 'del','author' => author,'changeset' => ch,'description' => desc})
    end  
    
    #puts "file_id: "+ file_id.to_s 
    #puts "controller_name: " + controller_name.classify

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