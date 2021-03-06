class AbsencesController < ApplicationController
  include CommonHelper

  before_action :logged_in_user
  before_action :set_absence, only: [:show, :edit, :update, :destroy]

  helper_method :sort_2, :dir_2 
  helper_method :sort_column, :sort_direction
  
  after_action  :send_changeset_email, only: [:update, :create]

  respond_to :html, :json, :js
 
  def index
    @wdays = %w(пн вт ср чт пт сб вс)
    @user_ids = User.actual.by_city(@main_city).ids
    @page = 0

    params['m'] = nil if params[:sort] != 'calendar'
    if params[:sort] == 'calendar'
      @current_month = params['m'].nil? ? Date.today.beginning_of_month : Date.parse(params['m']) 
      @curr_day = @current_month.beginning_of_month.beginning_of_week
      @birthdays = User.actual.by_city(current_user.city_id)
                       .where('date_birth is NOT NULL').pluck(:name, :date_birth)
                       .map{|a, b| [b.try('strftime', '%d.%m'), a] }.to_h
    else
      @sort_column = sort_column
      @only_actual = params[:only_actual].nil? ? true : params[:only_actual] == 'true'
      query_str = "absences.*, date_trunc('month', dt_from) AS month"

      @page = params[:page].try(:to_i)
      @page = 1 if @page ==0 || @page.nil?

      abs = is_manager? ? Absence.all : current_user.absences
      @absences = abs.select(query_str).joins(:reason)
      @absences = @absences.where(user_id: @user_ids)


      if params[:sort] == 'users.name'
        sort_1 = "users.name"
        @absences = @absences.joins(:user)
      end
      @absences = @absences.where("dt_from >= ?", Date.today-2.week ) if @only_actual
      @absences = @absences.where('extract(year from dt_from) = ?', @params[:year]) if @params[:year].present?
      @absences = @absences.paginate(page: @page, per_page: 50)
      sort_1 = @sort_column == 'dt_from' ? 'month' : @sort_column
      order = "#{sort_1} #{sort_direction}, #{sort_2} #{dir_2}, absences.created_at desc"
      @absences = @absences.order(order)
    end

    puts "@current_month #{@current_month}, params['sort'] #{params['sort']}"

    @search = params[:search]
    @json_data = Absence.by_year(@year[:id]).map{ |a| { id: a.id,  #.where("dt_from >= ?", (Date.today - 1.week))
                     # address: a.project_name,
                      actual: a.dt_from > (Date.today - 52.week),
                     dt_from: format_date(a.dt_from),
                       dt_to: format_date(a.dt_to),
                        user: a.user_name,
                      reason: a.reason_name,
                project_name: a.project_name,
                       month: month_year(a.dt_from),
                        year: a.dt_from.year,
                   time_from: f_time(a.dt_from),
                     time_to: f_time(a.dt_to),
                       group: a.dt_from }}

    @columns = %w"dt_from:Дата_с dt_to:Дата_по user reason project_name time_from:С time_to:По"
    fields  = %w"".concat(@columns)                   

    @reasons = AbsenceReason.order(:id).map{ |e| {name: e.name.strip, id: e.id } }
    @params = params.permit(params.except(:controller, :action).keys).to_h
    
    @users = User.actual #.by_city(current_user.city)
  end

  def show
    @title = 'Просмотр данных об отсутствии'
    @shops  = @absence.shops

    @shop  = AbsenceShop.new
    @shop_targets = AbsenceShopTarget.all
    @dt_from = @absence.dt_from.try('strftime',"%d.%m.%Y")
    @dt_to = @absence.dt_to.try('strftime',"%d.%m.%Y")
    @t_to = @absence.dt_to.try('strftime',"%H:%M")
    @t_from = @absence.dt_from.try('strftime',"%H:%M")
    @checked = @absence.dt_from.beginning_of_day != @absence.dt_to.beginning_of_day
    
    respond_modal_with @absence, location: root_path
  end

  def abs_params(ap = nil)
    @shop     = AbsenceShop.new
    @reasons  = AbsenceReason.order(:id)
    @targets  = AbsenceTarget.order(:name)
    @users    = User.actual.by_city(current_user.city)
    @projects = Project.only_actual(true).order(:address).map{|p| {label: p.name, 
                  value: p.id, executor_id: p.executor_id, non_actual: false}} + 
                Project.non_actual.order(:address).map{|p| {label: p.name, 
                  value: p.id, executor_id: p.executor_id, non_actual: true}}

    @shop_targets = AbsenceShopTarget.all

    # console
    # puts "@absence #{@absence.is_new?}"
    if !@absence.nil? && !@absence.new_record?
      @ashops   = @absence.shops.map{|s| { id: s.id,
                    shop: {label: s.shop_name, value: s.shop_id}, 
                    target: {label: s.target_name, value: s.target_id},
                    _destroy: false}} 

      @dt_from  = @absence.dt_from.try('strftime',"%d.%m.%Y")
      @t_from   = @absence.dt_from.try('strftime',"%H:%M")
      @dt_to    = @absence.dt_to.try('strftime',"%d.%m.%Y")
      @t_to     = @absence.dt_to.try('strftime',"%H:%M")
      @checked  = @absence.dt_from.beginning_of_day != @absence.dt_to.beginning_of_day
      @shops    = @absence.shops
    else
      @shops    = {}
    end
  end
  # GET /absences/new
  def new
    @absence = Absence.new
    abs_params
    @dt_from = DateTime.now.try('strftime',"%d.%m.%Y")
    @dt_to = @dt_from
    @t_from = "10:00"
    @t_to = '19:00'

    @checked = false
    @shops = @absence.shops

  end

  # GET /absences/1/edit
  def edit
    if !is_manager? && @absence.user != current_user
      redirect_to absences_path
    end
    abs_params
  end

  # POST /absences
  # POST /absences.json
  def create
    @absence = Absence.new(absence_params)

    respond_to do |format|
      if @absence.save
        format.html { redirect_to absences_url, notice: 'Отсутствие успешно создано.' }
        format.json { render :edit, status: :created, location: @absence }
      end
    end
  end

  # PATCH/PUT /absences/1
  # PATCH/PUT /absences/1.json
  def update
    ap = absence_params
    reason_id = ap[:reason_id].try('to_i')
    if reason_id.present?
      ap[:project_id]=0 if ![2, 3].include?(reason_id)
      ap[:target_id]=0 if reason_id != 2
    end

    abs_params
    respond_to do |format|
      if @absence.update(ap)
        format.html { redirect_to absences_url, notice: 'Отсутствие успешно обновлено.' }
        format.json { render :edit, status: :ok, location: @absence }
      else
        format.html { render :edit }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /absences/1
  # DELETE /absences/1.json
  def destroy
    @absence.destroy
    respond_to do |format|
      format.html { redirect_to absences_url, notice: 'Отсутствие успешно удалено.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_absence
      @absence = Absence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def absence_params
      a = params.require(:absence).permit(:user_id, :dt_from, :dt_to, :reason_id, 
                                          :new_reason_id, :comment, :project_id,
                                          :t_from, :t_to, :checked, :target_id, 
                                          :canceled, :approved, 
                                          shops_attributes: [:id, :shop_id, :target_id, :_destroy])

      a['dt_to'] = a['dt_from'] if a['checked']=='false' || a['dt_to'].nil?
      a['dt_from'] = a['dt_from'].gsub("00:00", '')+ ' ' + a['t_from']
      a['dt_to'] = a['dt_to'].gsub("00:00", '') +' ' + a['t_to']
      a
    end

    def sort_column
      col_names = Absence.column_names + ['users.name', 'calendar']
      col_names.include?(params[:sort]) ? params[:sort] : "dt_from"
    end

    def sort_direction
      default_dir = 'desc'#sort_column =='dt_from' ? "asc": "desc"
      %w(asc desc).include?(params[:direction]) ? params[:direction] : default_dir
    end

    def sort_2
      Absence.column_names.include?(params[:sort2]) ? params[:sort2] : "dt_from"
    end

    def dir_2
      defaul_dir = (sort_column =='dt_from' && @only_actual) ? "asc": "desc"
      %w(asc desc).include?(params[:dir2]) ? params[:dir2] : defaul_dir
    end

    def send_changeset_email
      # puts "controller.action_name #{controller.action_name}"
      # @version = @absence.versions.last
      # if !@version.nil?
      #   if @version.event == "create"
      if action_name == 'create'
        AbsenceMailer.created_email(@absence.id, current_user).deliver_now
      else
        AbsenceMailer.changeset_email(@absence.id, current_user).deliver_now
      end
      # end
    end

end
