class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :check_sum, only: [:create,:update]
  helper_method :sort_2, :dir_2
  helper_method :sort_column, :sort_direction
  respond_to :html, :json
  # GET /projects
  # GET /projects.json
  def index
    @sort_column = sort_column
    @only_actual = params[:only_actual].nil? ? true : params[:only_actual]=='true'
    query_str = "projects.*, date_trunc('month', date_start) AS month"
    if !current_user.admin?
      @projects = current_user.projects.select(query_str)
    else
      @projects = Project.select(query_str)
    end

    if !params[:search].nil?
      @projects = @projects.where('LOWER(address) like LOWER(?)','%'+params[:search]+'%')
    end

    if @only_actual
      @projects = @projects.where('pstatus_id in (1,2)')
    end

    if params[:sort] == 'users.name'
      sort_1 = "executor.name"
      @projects = @projects.joins(:executor)      
    end

    sort_1 = @sort_column #== 'date_end_plan' ? 'month' : @sort_column
    p sort_1
    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", projects.created_at desc"
    @projects = @projects.order(order)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @title = 'Просмотр проекта'

    @comm_height = 488
    respond_modal_with @project, location: root_path
    data = params[:data]
    get_debt(data)
  end

  # GET /projects/new
  def new
    @project = Project.new
    @client =  @project.build_client
    get_debt
  end

  # GET /projects/1/edit
  def edit
    get_debt
    @comm_height = 350
    @owner = @project
  end

  # POST /projects
  # POST /projects.json
  def create
    pp = project_params
    pp['pstatus_id'] ||= 1
    @project = Project.new(pp)
    @client = @project.create_client(project_params[:client_attributes])

    @client.save

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_url, notice: 'Проект успешно создан' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    p project_params
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_url, notice: 'Проект успешно сохранен' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
    p @project
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Проект успешно удален' }
      format.json { head :no_content }
    end
  end

  private
    def get_debt(to_date = '')
      if to_date == ''
        @cl_payments = @project.receipts.where(provider_id: 0).order(:date)
      else
        @cl_payments = @project.receipts.where('provider_id = 0 and date < ?', to_date).order(:date)
      end
        
      @cl_total = @cl_payments.sum(:sum)
      @cl_debt  =  (@project.total - @cl_total).to_i
    end

    def check_sum
      prms = ['price','price_2','price_real','price_2_real','sum','sum_2','sum_real','sum_2_real','sum_total','sum_total_real','designer_price', 'designer_price_2','visualer_price']
      prms.each do |p|
        project_params[p] = project_params[p].gsub!(' ','') if !project_params[p].nil?
        p p,project_params[p]
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:client_id, :address, :owner_id, :executor_id, :designer_id, :visualer_id, :project_type_id, 
        :date_start, :date_end_plan, :date_end_real, :number, :date_sign, 
        :footage, :footage_2, :footage_real, :footage_2_real, :style_id, 
        :sum, :sum_total, :sum_real, :price, :price_2, :price_real,  :sum_2, :sum_total_real, :sum_2_real, :price_2_real, 
        :month_in_gift, :act, :delay_days,  :pstatus_id, :attention, 
        :designer_price, :designer_price_2,:visualer_price,
        :client_attributes => [:name, :address, :phone, :email] )
    end

    def sort_column
      default_column = "number"
      (Project.column_names.include?(params[:sort]) || params[:sort] == 'users.name' ) ? params[:sort] : default_column
    end

    def sort_direction
      defaul_dir = sort_column =='number' ? "asc": "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
    end

    def sort_2
      "date_end_plan"
    end

    def dir_2 
      "desc"
    end

end
