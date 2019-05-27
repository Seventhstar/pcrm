class FileController < ApplicationController
require 'uri'
respond_to :html, :json
before_action :logged_in_user


   def del_file
     if params[:file_id]
        file = Attachment.find(params[:file_id])
        num_to_s = file.owner_id.to_s
        filename = Rails.root.join('public', 'uploads',file.owner_type,num_to_s,file.id.to_s+File.extname(file.name))
        File.delete(filename) if File.exist?(filename)
        file.destroy
     end
     render nothing: true
   end

  def show
    @img = '/download/'+params[:path]
    respond_modal_with @img, location: root_path
  end

  def create_file

    if params[:file] || params[:files]
      folder = params[:owner_type].classify
      subfolder = params[:owner_id]
      uploaded_io = params[:file]

      name = check_file_name(uploaded_io.original_filename, subfolder, folder)
      dir = Rails.root.join('public', 'uploads', folder, subfolder)

      FileUtils.mkdir_p(dir) unless File.exists?(dir)
      id = append_file(name)
      open(dir+(id.to_s+File.extname(name)), 'wb') do |file|
         file.write(uploaded_io.read)
      end

        
    end
    render layout: false, content_type: "text/html"
  end

  def check_file_name(filename,id, type)
     extn = File.extname filename
     name = File.basename filename, extn

     f = Attachment.where('owner_id = ? and owner_type = ? and name like ? ' ,id,type, name+"%" ).order('created_at desc').first 
     if f
        extn = File.extname f.name
        name = File.basename f.name, extn
        if name.split('(').count>1 
           s = name.split('(').last.split(')').first.to_i
           name = name.split("("+s.to_s+")").first
           name = name+"("+(s+1).to_s + ")"+extn
        else
           name = name+"(1)"+extn
        end 
        newname = name
     else
        filename
     end
     
  end

  def append_file(filename) #,lead_id
    f = Attachment.new
    f.owner_id = params[:owner_id]
    f.owner_type = params[:owner_type].classify
    f.user_id = current_user.id
    f.name = filename
    f.save
    f.id
  end

  def download
    dir = Rails.root.join('public', 'uploads', params[:type], params[:id], params[:basename]+"."+params[:extension])
    f = Attachment.find(params[:basename])
    send_file dir, disposition: 'attachment', filename: f.name
  end

end
