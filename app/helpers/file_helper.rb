module FileHelper

  def audio_file(lead)
    file = lead.attachments.select{ |f| ['mp3', 'ogg'].include?(f.name.last(3)) if !f.nil? }.first
  end

  def file_default_action(file, add_name=nil, decoration=true)    
    file = Attachment.find(file) if file.class == Integer

    if file.nil? 
      return
    end
    filename = add_name.nil? ? file.name : [file.name,add_name].join(' ')
    extension = file.name.split('.').last

    case extension
    when 'jpg', 'png', 'gif'
      a = link_to filename, file.show_path, class: 'icon_img', data: { modal: true }
      if decoration
        content_tag :div, class: 'fname' do
          a
        end
      else
        a  
      end

    when 'mp3', 'ogg'
      a = content_tag :span do
        filename[0..-5]
      end
      
      b = content_tag 'audio', 'controls':'' do
        content_tag 'source', src: file.download_path, type: "audio/mp3" do
        end
      end

      content_tag :div, class: 'fname audio' do
        a + b
      end

    else  
      a = link_to filename, file.download_path, class: "icon_doc" , target: "_blank" #{}"_tab"
    end
    
  end

end
