class AbsencesController < ApplicationController
  before_action :set_absence, only: [:show, :edit, :update, :destroy]
  helper_method :sort_2, :dir_2
  helper_method :sort_column, :sort_direction

  # GET /absences
  # GET /absences.json
  def index
    @wdays = ['пн','вт','ср','чт','пт','сб','вс']
    
    @current_month = Date.parse(params['m']) if !params['m'].nil?
    @current_month = Date.today if @current_month.nil? 
    @curr_day = @current_month.beginning_of_month.beginning_of_week
    query_str = "absences.*, date_trunc('month', dt_from) AS month"
    @sort_column = sort_column

    if !current_user.admin?
      @absences = current_user.absences.select(query_str)
    else
      @absences = Absence.select(query_str)
    end

    @absences = @absences.where("dt_from >= ?",@curr_day)

    if params[:sort] == 'users.name'
      sort_1 = "users.name"
      @absences = @absences.joins(:user)      
    end

    sort_1 = @sort_column == 'dt_from' ? 'month' : @sort_column
    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", absences.created_at desc"
    p "order",order
    @absences = @absences.order(order)
  end

  # GET /absences/1
  # GET /absences/1.json
  def show
    @shops  = @absence.shops
    @shop  = AbsenceShop.new
    @shop_targets = AbsenceShopTarget.all

  end

  # GET /absences/new
  def new
    @absence = Absence.new
    @reasons = AbsenceReason.all
    @targets = AbsenceTarget.all
    @projects = Project.all
    @dt_from = DateTime.now.try('strftime',"%d.%m.%Y")
    @dt_to = @dt_from
    @t_from = "10:00"
    @t_to = '19:00'
    @checked = false
    @shops = {}
    @shop  = AbsenceShop.new
    @shop_targets = AbsenceShopTarget.all
  end

  # GET /absences/1/edit
  def edit
    @reasons = AbsenceReason.all
    @projects = Project.all
    @targets = AbsenceTarget.all
    @shops  = @absence.shops
    @shop  = AbsenceShop.new
    @shop_targets = AbsenceShopTarget.all
    @dt_from = @absence.dt_from.try('strftime',"%d.%m.%Y")
    @dt_to = @absence.dt_to.try('strftime',"%d.%m.%Y")
    @t_from = @absence.dt_from.try('strftime',"%H:%M")
    @t_to = @absence.dt_to.try('strftime',"%H:%M")
    @checked = @absence.dt_from.beginning_of_day != @absence.dt_to.beginning_of_day 
  end

  # POST /absences
  # POST /absences.json
  def create
    @absence = Absence.new(absence_params)

    respond_to do |format|
      if @absence.save
        format.html { redirect_to absences_url, notice: 'Отсутствие успешно создано.' }
        format.json { render :show, status: :created, location: @absence }
      else
        format.html { render :new }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /absences/1
  # PATCH/PUT /absences/1.json
  def update
    respond_to do |format|

      if @absence.update(absence_params)
        format.html { redirect_to absences_url, notice: 'Отсутствие успешно обновлено.' }
        format.json { render :show, status: :ok, location: @absence }
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
      a = params.require(:absence).permit(:user_id, :dt_from, :dt_to, :reason_id, :new_reason_id, :comment, :project_id,:t_from,:t_to,:checked, :target_id)
      a['dt_to'] = a['dt_from'] if a['checked']=='false' || a['dt_to'].nil?
      a['dt_from'] = a['dt_from'].gsub("00:00", '')+ ' ' + a['t_from']
      
      a['dt_to'] = a['dt_to'].gsub("00:00", '') +' ' + a['t_to'] 
      
      a
    end

    def sort_column
      p "params[:sort]",params[:sort]
      default_column = "dt_from"
      (Absence.column_names.include?(params[:sort]) || params[:sort] == 'users.name' || params[:sort] == 'calendar' ) ? params[:sort] : default_column
    end

    def sort_direction
      default_dir = sort_column =='dt_from' ? "asc": "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : default_dir
    end

    def sort_2
      "dt_from"
    end

    def dir_2 
      "desc"
    end
end
