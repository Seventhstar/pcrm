class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in_user
      unless logged_in?
        store_location
        # flash[:danger] = "Выполните вход."
        redirect_to login_url
      end
  end

  def create_file
    if params[:file] || params[:files]
      puts params[:file].original_filename
      uploaded_io = params[:file]

      name = check_file_name(uploaded_io.original_filename,params[:leadid])
      File.open(Rails.root.join('public', 'uploads','leads', name), 'wb') do |file|
         file.write(uploaded_io.read)
      end
      append_file(name,params[:leadid])

    end
    #render :nothing => true
    render layout: false, content_type: "text/html"
  end

  def check_file_name(filename,lead_id)
     extn = File.extname filename
     name = File.basename filename, extn
     f = LeadsFile.where('lead_id = ? and name like ? ' ,lead_id, name+"%" ).order('created_at desc').first
     puts f.name
     if f

        extn = File.extname f.name
        name = File.basename f.name, extn
        if name.split('(').count>1 
           s = name.split('(').last.split(')').first.to_i
           name = name.split("("+s.to_s+")").first
           name = name+"("+(s+1).to_s + ")"+extn
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


end
