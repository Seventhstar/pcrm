module LeadsHelper

 def is_update_form?
     controller.action_name == 'edit_multiple'
 end

 def find_version_author_name(version)
    user = User.find_version_author(version) 
    user ? user.name : ''
 end

 def channel_name(ch_id)
    if ch_id.present?
       channel=Channel.find(ch_id)
       channel.name 
    else 
      ""
    end
 end

 def status_name(st_id)
   	if st_id.present?
       Status.find_by_id(st_id).try(:name)
   	else
   	  ""	
   	end
 end 

  def user_name(id)
    if !id.nil? && id!=0
     user = User.find(id)
     user ? user.name : ''
    else
      ""
    end
    
  end


 def leads_page_url
    session[:last_leads_page] || leads_url
 end
 
 def store_leads_path
    session[:last_leads_page] = request.url || leads_url if request.get?
 end

 def multi_edit_icon
    if current_user.admin? 
      link_to edit_multiple_leads_path, {:class => 'li-right splink'} do #splink
        image_tag('edit.png')
      end
    end
 end

def get_lead_history(lead)
    history = Hash.new
    # изменения в самом лиде
    lead.versions.reverse.each do |version|
      if version[:event]!="create" && version != lead.versions.first 
        author = find_version_author_name(version) 
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        changeset = version.changeset 
        ch = Hash.new
        changeset.keys.each_with_index do |k,index| 
          if k=="updated_at"
          elsif k=="channel_id"
            ch.store( index, {'field' => t(k), 'from' => channel_name(changeset[k][0]), 'to' => channel_name(changeset[k][1]) } )
          elsif k=="status_id"
            ch.store( index, {'field' => t(k), 'from' => status_name(changeset[k][0]), 'to' => status_name(changeset[k][1]) } )
          elsif k=="user_id" || k=="ic_user_id"
            ch.store( index, {'field' => t(k), 'from' => user_name(changeset[k][0]), 'to' => user_name(changeset[k][1]) } )
          else
            ch.store( index, {'field' => t(k), 'from' => changeset[k][0], 'to' => changeset[k][1] } )
          end
        end
        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch})
      end
    end
    # созданные файлы
    lead.leads_files.each do |file|
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
