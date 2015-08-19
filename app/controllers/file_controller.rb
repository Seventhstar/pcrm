class FileController < ApplicationController
before_action :logged_in_user
   def del_file
     if params[:file_id]
        #puts "!!type: " + params[:type]
        if params[:type] == 'leads'
           file = LeadsFile.find(params[:file_id])
           num_to_s = file.lead.id.to_s
        else
          file = DevelopsFile.find(params[:file_id])
          num_to_s = file.develop.id.to_s
        end

        filename = Rails.root.join('public', 'uploads',params[:type],num_to_s,file.name)
        #puts 'filename: '+filename.to_s
        File.delete(filename) if File.exist?(filename)
        file.destroy
     end
     render :nothing => true
   end

  def create_file

    if params[:file] || params[:files]

      dev_file  = params[:leadid].nil? ? true : false
#      folder    = controller_name #dev_file ? 'develops' : 'leads'
      folder    = dev_file ? 'develops' : 'leads'
      subfolder = dev_file ? params[:devid] : params[:leadid]

      #puts params[:file].original_filename
      uploaded_io = params[:file]

      name = check_file_name(uploaded_io.original_filename,subfolder,folder)
      dir = Rails.root.join('public', 'uploads',folder,subfolder)

      FileUtils.mkdir_p(dir) unless File.exists?(dir)
      File.open(dir + name, 'wb') do |file|
         file.write(uploaded_io.read)
      end

      if dev_file 
        append_dev_file(name,params[:devid])
      else  
        append_file(name,params[:leadid])
      end

    end
    render layout: false, content_type: "text/html"
  end

  def check_file_name(filename,id, type)
     extn = File.extname filename
     name = File.basename filename, extn

     if type =='leads'
      f = LeadsFile.where('lead_id = ? and name like ? ' ,id, name+"%" ).order('created_at desc').first
     else
      f = DevelopsFile.where('develop_id = ? and name like ? ' ,id, name+"%" ).order('created_at desc').first
     end

     
     if f
        #puts f.name
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

  def append_file(filename,lead_id)
     f = LeadsFile.new
     f.lead_id = lead_id
     f.user_id = current_user.id
     f.name = filename
     f.save
  end

  def append_dev_file(filename,dev_id)
     f = DevelopsFile.new
     f.develop_id = dev_id
     f.name = filename
     f.save
  end


  def download
    #puts params[:filename]
    dir = Rails.root.join('public', 'uploads',params[:type],params[:id],params[:basename]+"."+params[:extension])
    send_file dir, :disposition => 'attachment'
    flash[:notice] = "Файл успешно загружен"
  end

end
