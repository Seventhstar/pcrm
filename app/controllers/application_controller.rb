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
      File.open(Rails.root.join('public', 'uploads','leads', uploaded_io.original_filename), 'wb') do |file|
         file.write(uploaded_io.read)
      end

    end
    #render :nothing => true
    render layout: false, content_type: "text/html"
  end


end
