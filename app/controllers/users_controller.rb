class UsersController < ApplicationController
  include VueHelper
  include DatesHelper
  include Navigable
  
  before_action :logged_in_user
#, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  respond_to :html, :json
  before_action :main_params, only: [:show]

  # GET /users
  # GET /users.json
  def index
    # puts "@only_actual #{@only_actual}"
    @users = User.order(:name)
    @items = @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    cur_year = Date.today.year

    @holidays   = Holiday.pluck(:day).collect{|d| js_date(d)}
    @workdays   = WorkingDay.pluck(:day).collect{|d| js_date(d)}

    
    first_project = @user.projects.order(:date_start).first
    first_project = first_project.nil? ? cur_year : first_project[:date_start].year

    first_lead    = @user.leads.order(:start_date).first
    first_lead    = first_lead.nil? ? cur_year : first_lead[:start_date].year

    @reasons = AbsenceReason.order(:id)

    years = [[first_project, first_lead].min, cur_year]
    @years = (years[0]..years[1]).map{|y| {id: y, name: y }}
    # @year = {id: cur_year, name: cur_year}
    @leads = @user.leads


    @user_leads = for_vue(@user.leads
                                .select("leads.*, date_trunc('year', start_date) AS year")
                                .order(:status_id, :start_date), 
                  "status_name")

    @user_projects = for_vue(@user.projects
                                  .select("projects.*, extract(year from date_start) AS year")
                                  .order(:pstatus_id, :date_start), 
                            [:status_name, :project_type_name, :date_end])
  end

  
  def new
    @user = User.new
    @user.city = current_user.city
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
    @cities = City.order(:id)
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
                                   :password_confirmation, :avatar, :city_id)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      redirect_to(root_url) unless (current_user.id == params[:id].try(:to_i) || current_user.admin?)
      @user = User.find_by(id: params[:id])
      # redirect_to(root_url) unless current_user.admin?
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
