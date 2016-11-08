class AbsencesController < ApplicationController
  include CommonHelper
  respond_to :html, :json
  before_action :set_absence, only: [:show, :edit, :update, :destroy]
  helper_method :sort_2, :dir_2
  helper_method :sort_column, :sort_direction
  before_action :logged_in_user
  after_filter  :send_changeset_email, only: [:update,:create]

  # GET /absences
  # GET /absences.json
  def index
    @wdays = ['пн','вт','ср','чт','пт','сб','вс']
    @sort_column = sort_column
    @only_actual = params[:only_actual].nil? ? true : params[:only_actual]=='true'
    params['m'] = nil if  params[:sort]!='calendar'
    @current_month = Date.parse(params['m']) if !params['m'].nil?
    @current_month = Date.today.beginning_of_month if @current_month.nil?
    @curr_day = @current_month.beginning_of_month.beginning_of_week
    query_str = "absences.*, date_trunc('month', dt_from) AS month"

    if !current_user.admin?
      @absences = current_user.absences.select(query_str)
    else
      @absences = Absence.select(query_str)
    end

    if params[:sort]!='calendar'
      if @only_actual
        @absences = @absences.where("dt_from >= ?", (Date.today-2.week))
      end
    else
      @absences = @absences.where("dt_from >= ?",@curr_day)
    end

    if params[:sort] == 'users.name'
      sort_1 = "users.name"
      @absences = @absences.joins(:user)
    end

    sort_1 = @sort_column == 'dt_from' ? 'month' : @sort_column
    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", absences.created_at desc"
    # p "sort",sort_1,sort_direction
    @absences = @absences.order(order)
  end

  # GET /absences/1
  # GET /absences/1.json
  def show
    @title = 'Просмотр данных об отсутствии'
    @shops  = @absence.shops
    @shop  = AbsenceShop.new
    @shop_targets = AbsenceShopTarget.all
    @dt_from = @absence.dt_from.try('strftime',"%d.%m.%Y")
      @dt_to = @absence.dt_to.try('strftime',"%d.%m.%Y")
      @t_from = @absence.dt_from.try('strftime',"%H:%M")
      @t_to = @absence.dt_to.try('strftime',"%H:%M")
      @checked = @absence.dt_from.beginning_of_day != @absence.dt_to.beginning_of_day
    respond_modal_with @absence, location: root_path
  end

  def abs_params(ap = nil)
    @reasons = AbsenceReason.order(:id)
    @targets = AbsenceTarget.order(:name)
    @projects = Project.all
    @shop  = AbsenceShop.new
    @shop_targets = AbsenceShopTarget.all
    @reopen = false
    #p  "current_user.id",current_user.id
    @user = current_user.id
    if !@absence.nil?
      @user = @absence.user_id
      @shops  = @absence.shops
      @dt_from = @absence.dt_from.try('strftime',"%d.%m.%Y")
      @dt_to = @absence.dt_to.try('strftime',"%d.%m.%Y")
      @t_from = @absence.dt_from.try('strftime',"%H:%M")
      @t_to = @absence.dt_to.try('strftime',"%H:%M")
      @checked = @absence.dt_from.beginning_of_day != @absence.dt_to.beginning_of_day
    end
  end
  # GET /absences/new
  def new
    abs_params
    @absence = Absence.new
    @dt_from = DateTime.now.try('strftime',"%d.%m.%Y")
    @dt_to = @dt_from
    @t_from = "10:00"
    @t_to = '19:00'

    @checked = false
    @shops = {}

  end

  # GET /absences/1/edit
  def edit
    if !current_user.admin? && @absence.user != current_user
      redirect_to absences_path
    end
    abs_params


  end

  # POST /absences
  # POST /absences.json
  def create
    @absence = Absence.new(absence_params)
    reopen = absence_params[:reopen]=='true'
    @reopen = reopen

    respond_to do |format|
      if @absence.save
        if absence_params[:reopen]=='true'
          format .html { redirect_to action: "edit", id: @absence.id }
        else
          format .html { redirect_to absences_url, notice: 'Отсутствие успешно создано.' }
        end
        format.json { render :edit, status: :created, location: @absence }
      else
        abs_params
        @reopen = reopen
        format .html { render "new" }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /absences/1
  # PATCH/PUT /absences/1.json
  def update
    ap = absence_params
    ap[:project_id]=0 if ap[:reason_id].to_i<2 || ap[:reason_id].to_i>3
    ap[:target_id]=0 if ap[:reason_id].to_i!=2

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
      a = params.require(:absence).permit(:user_id, :dt_from, :dt_to, :reason_id, :new_reason_id, :comment, :project_id,:t_from,:t_to,:checked, :target_id,:reopen)
      a['dt_to'] = a['dt_from'] if a['checked']=='false' || a['dt_to'].nil?
      a['dt_from'] = a['dt_from'].gsub("00:00", '')+ ' ' + a['t_from']
      a['dt_to'] = a['dt_to'].gsub("00:00", '') +' ' + a['t_to']
      a
    end

    def sort_column
      col_names = Absence.column_names + ['users.name','calendar']
      col_names.include?(params[:sort]) ? params[:sort] : "dt_from"
    end

    def sort_direction
      default_dir = 'desc'#sort_column =='dt_from' ? "asc": "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : default_dir
    end

    def sort_2
      Absence.column_names.include?(params[:sort2]) ? params[:sort2] : "dt_from"
    end

    def dir_2
      defaul_dir = sort_column =='dt_from' ? "asc": "desc"
      %w[asc desc].include?(params[:dir2]) ? params[:dir2] : defaul_dir
    end

    def send_changeset_email
      @version = @absence.versions.last
      if !@version.nil?
        if @version.event == "create"
          AbsenceMailer.created_email(@absence.id,current_user).deliver_now
        else
          AbsenceMailer.changeset_email(@absence.id,current_user).deliver_now
        end
      end
    end

end
