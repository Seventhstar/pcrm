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
        changeset.keys.each_with_index do |k,index| 
          
          from=""
          to=""
          case k 
          when "updated_at"
          when "coder","boss"
            from = t(changeset[k][0].to_s)
            to = t(changeset[k][1].to_s) 
          when "channel_id"
            from = channel_name(changeset[k][0])
            to = channel_name(changeset[k][1]) 
          when "status_id"
            from = status_name(changeset[k][0])
            to = status_name(changeset[k][1])
          when "priority_id"
            from = priority_name(changeset[k][0])
            to = priority_name(changeset[k][1]) 
          when "user_id","ic_user_id"
            from = user_name(changeset[k][0])
            to = user_name(changeset[k][1]) 
          else
            from = changeset[k][0]
            to = changeset[k][1]
          end

          if from.present? || to.present?
            ch.store( index, {'field' => t(k), 'from' => from, 'to' => to } )
          end
        end
        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch})
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
        history.store( at, {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch})
      end  
    end
    # удаленные файлы
    file_id = []
    deleted = PaperTrail::Version.where_object(lead_id: lead.id)
    deleted.each_with_index do |file,index|
      ch = Hash.new  
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
      ch.store( index, {'file' =>  a['name']} )
      history.store( at, {'at' => at_hum,'type'=> 'del','author' => author,'changeset' => ch})
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
      history.store( at, {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch})
    end  
    history.sort.reverse
  end


end