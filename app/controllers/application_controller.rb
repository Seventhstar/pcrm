class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	
  include SessionsHelper


	def download
		puts params[:filename]
		dir = Rails.root.join('public', 'uploads','leads',params[:lead],params[:basename]+"."+params[:extension])
		send_file dir, :disposition => 'attachment'
		flash[:notice] = "Файл успешно загружен"
	end

  def logged_in_user
      unless logged_in?
        store_location
        # flash[:danger] = "Выполните вход."
        redirect_to login_url
      end
  end

  def create_file

    if params[:file] || params[:files]

      dev_file =  params[:leadid].nil? ? true : false
      folder = dev_file ? 'dev' : 'leads'
      subfolder = dev_file ? params[:devid] : params[:leadid]

      puts params[:file].original_filename
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

  def check_file_name(filename,lead_id, type)
     extn = File.extname filename
     name = File.basename filename, extn

     if type =='leads'
      f = LeadsFile.where('lead_id = ? and name like ? ' ,lead_id, name+"%" ).order('created_at desc').first
     else
      f = DevFile.where('develop_id = ? and name like ? ' ,lead_id, name+"%" ).order('created_at desc').first
     end

     
     if f
		    puts f.name
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
     f = DevFile.new
     f.develop_id = dev_id
     f.name = filename
     f.save
  end

end
