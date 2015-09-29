class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  # GET /projects
  # GET /projects.json
  def index
      if !params[:prj_search].nil?
      @projects = Project.where('LOWER(address) like LOWER(?)','%'+params[:prj_search]+'%').order(:date_end_plan)
    else
      @projects = Project.order(:date_end_plan)
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @client =  @project.build_client
  end

  # GET /projects/1/edit
  def edit
    @cl_payments = @project.receipts.where(provider_id: 0).order(:date)
    @cl_total = @cl_payments.sum(:sum)
    
    sum1 = @project.price_real * @project.footage_real
    sum1 = @project.price * @project.footage if sum1 <1
    sum2 = @project.price_2_real * @project.footage_2_real
    sum2 = @project.price_2 * @project.footage_2 if sum2 <1

    @cl_debt  =  (sum2 + sum1 - @cl_total).to_i
  end

  # POST /projects
  # POST /projects.json
  def create
    
    @project = Project.new(project_params)
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
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_url, notice: 'Проект успешно сохранен' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:client_id, :address, :owner_id, :executor_id, :designer_id, :project_type_id, :date_start, :date_end_plan, :date_end_real, :number, 
        :footage, :footage_2, :footage_real, :footage_2_real, :style_id, :sum, :sum_real, :price, :price_2, :price_real, :price_2_real, 
        :month_in_gift, :act, :delay_days, :sum_total, :sum_2, :sum_total_real, :date_sign, :client_attributes => [:name, :address, :phone, :email] )
    end

end
