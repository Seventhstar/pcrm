require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include SessionsHelper
  include Navigable
  
  protect_from_forgery with: :exception
  before_action :check_policy
  before_action :main_params, only: [:index]
  before_action :set_paper_trail_whodunnit
  before_action :gon_user

  def default_url_options 
    if Rails.env.production?
      {host: "crmpp.ru"}
    else  
      {}
    end
  end    

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
    @params = params
    @only_actual = params[:only_actual].present? ? params[:only_actual]=='true' : true
    # @params[:only_actual] = @only_actual
  end

  private

    def gon_user
      if current_user
        gon.user_id = current_user.id 
        gon.admin = current_user.admin?  
      end
    end

end