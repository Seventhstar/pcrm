class SessionsController < ApplicationController
  
  def new

  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # p "i`m in session"
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)

        if current_user.has_role?(:designer)
          default_url = :projects
        else
          default_url = :leads
        end
        # session[:return_to] ||= default
        if session[:forwarding_url] == root_url 
          p "default_url #{default_url}"
          redirect_to default_url
        else
          redirect_back_or :leads
        end
        # if current_user.projects.count >0
        #   redirect_to projects_url 
        # else
           # p "back #{:back} request.referer #{request.referer}"
           # p "default_url #{default_url}"
           # p "session[:forwarding_url] #{session[:forwarding_url]}"
          
        # end
      else
        message  = "Аккаунт не активирован. "
#        message += "Проверьте свой почтовый ящик на наличие ссылки активации."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Неверная комбинация email/пароль.'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
