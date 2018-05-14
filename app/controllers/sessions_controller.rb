class SessionsController < ApplicationController
  
  def new

  end

  def valid_session
    controller.stub!(:authorize).and_return(User)
  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
 
        default_url = current_user.has_role?(:designer) ? :projects : :leads

        if session[:forwarding_url] == root_url 
          redirect_to default_url
        else
          redirect_back_or :leads
        end
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
