class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_policy
  before_action :set_paper_trail_whodunnit
  before_action :gon_user
    
  include SessionsHelper

  def logged_in_user
      unless logged_in?
        store_location
        # flash[:danger] = "Выполните вход."
        redirect_to login_url
      end
  end

  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end

  def check_policy
#   p "current_user.roles #{current_user.has_roles}" if !current_user.nil?
  end

  private

    def gon_user
      gon.user_id = current_user.id if current_user
    end

end