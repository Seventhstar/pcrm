class UsersController < ApplicationController
  before_action :logged_in_user
#, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  respond_to :html, :json


  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  
  def new
    @user = User.new
    respond_modal_with @user, location: root_path
  end


  # GET /users/new
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      #flash[:info] = "На Ваш почтовый ящик отправлено письмо со ссылки на активацию аккаунта."
      redirect_to '/options/users'
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Профиль обновлен"

      
      @user.options.destroy_all
      if params[:options]
        params[:options].each do |option|
          opt = @user.options.new
          opt.option_id = option
          opt.value = true
          opt.save
        end
      end
      redirect_to '/options/users'
    else
      flash[:error] = @user.errors.full_messages
      render 'edit'
    end

  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удален"
    redirect_to '/options/users'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_params
      params.require(:user).permit(:name,:date_birth, :email, :password, :telegram,
                                   :password_confirmation, :avatar)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
#      redirect_to(root_url) unless current_user?(@user)
       redirect_to(root_url) unless current_user.admin?
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
