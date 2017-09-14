class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :update_client]
  before_action :logged_in_user
  before_action :check_sum, only: [:create,:update]
  helper_method :sort_2, :dir_2
  helper_method :sort_column, :sort_direction
  # attr_accessor :days,:sum_rest
  respond_to :html, :json

  include ProjectsHelper

  # GET /projects
  # GET /projects.json
  def index

    years = Project.select("projects.*, date_trunc('year', date_start) AS year").where('date_start IS NOT NULL').order('date_start')
    year_from = years.first.year
    year_to = years.last.year

    @years = (year_from.year..year_to.year).step(1).to_a.reverse

    @sort_column = sort_column
    @only_actual = params[:only_actual].nil? ? true : params[:only_actual]=='true'
    query_str = "projects.*, date_trunc('month', date_start) AS month"
    if !current_user.admin?
      @projects = current_user.projects.select(query_str)
    else
      @projects = Project.select(query_str)
    end

    # @projects = @projects.includes(:client)

    if !params[:executor_id].nil? && params[:executor_id]!='0'
      @projects = @projects.where(id: User.find(params[:executor_id]).projects.ids)
    end

    if !params[:search].nil?
      src = ('%'+params[:search]+'%').mb_chars.downcase
      cl_ids = Client.where('LOWER(name) like ? or LOWER(email) like ? or LOWER(phone) like ?',src,src,src).pluck(:id)
      cl_prj = Project.where(client_id: cl_ids) 
      search_prj =  @projects.where('LOWER(address) like ?',src).pluck(:id)
      @projects = @projects.where(id: cl_prj + search_prj)
    end



    if @only_actual
      @projects = @projects.where('not pstatus_id = 3')
    end



    y = params[:year] 
    if !y.nil? && y!='' && y.to_i>0
      @projects = @projects.where('EXTRACT(year FROM "date_start") = ?', y)
    end

    @executors = User.order(:name)

    sort_1 = @sort_column #== 'date_end_plan' ? 'month' : @sort_column
    @numsort = (sort_1 == "number") 
        

    if params[:sort] == 'executor_id'
      sort_1 = "users.name"

      @projects = @projects.includes(:executor)
    end

    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", projects.number desc"
    # p "sort_2, order #{order}"
    @projects = @projects.order(order)
    store_prj_path
    @sort = sort_1
    # p project_stored_page_url
  end
 
  # GET /projects/1
  # GET /projects/1.json
  def show

    respond_to do |format|
      p "format #{format}"
      format.html do
        @title = 'Просмотр проекта'
        @owner = @project
        @comm_height = 268
        respond_modal_with @project, location: root_path
        data = params[:data]
        get_debt(data) 
      end
      format.pdf do 
        pdf = ProjectPdf.new(@project) 
        send_data pdf.render, 
        filename: "project_#{@project.id}",
        type: 'application/pdf',
        page_layout: 'landscape',
        disposition: 'inline'
      end

    end
  end

  def def_params
    @owner = @project
    @holidays =  Holiday.pluck(:day).collect{|d| d.try('strftime',"%Y-%m-%d")}
    @gtypes = Goodstype.all
    # @files    = @lead.attachments
    # @history  = get_history_with_files(@lead)
  end

  # GET /projects/new
  def new
    @project = Project.new
    # @client =  @project.build_client
    # p :client_id
    get_debt
    def_params
  end

  # GET /projects/1/edit
  def edit
 
    def_goods = Goodstype.where(default: true)
    def_goods.each do |dg|
      pgt = ProjectGType.find_or_create_by({g_type_id: dg.id, project_id: @project.id})
    end

    @gs = params[:good_state]

    if !@gs.nil? && @gs.to_i>0
      @gs = @gs.to_i
    else
      @gs = 0
    end
    

    get_debt
    def_params
    @comm_height = 350
    @owner = @project
    @files        = @project.attachments
    @elongation_types = ElongationType.all
    @new_et  = ProjectElongation.new
    @new_gt  = Goodstype.new
    gt = @project.project_g_types.pluck(:g_type_id)
    @gtypes = gt.empty? ? Goodstype.order(:name) : Goodstype.where('not id in (?)',gt).order(:name)
    # @prj_good_types = @project.project_g_types.order("goodstype.name")
    @prj_good_types = ProjectGType.joins(:goodstype).where('g_type_id in (?) and project_id = ?',gt,@project.id).order('goodstypes.name')
    
  end

  # POST /projects
  # POST /projects.json
  def create
    pp = project_params
    pp['pstatus_id'] ||= 1
    @project = Project.new(pp)
    # p "project_params[:client_id]",project_params[:client_id]
    if project_params[:client_id] == "0" 
      # p "@client.save"
      @client = @project.create_client(client_params)
      @client.save
      @project.client_id = @client.id
    else
      @client = Client.find(project_params[:client_id])
    end

    respond_to do |format|
      if @project.save
        if params[:project][:first_comment] && !params[:project][:first_comment].empty?
          comm = @project.comments.new
          comm.comment = params[:project][:first_comment]
          comm.user_id = params[:project][:owner_id]
          comm.save
        end
        format.html { redirect_to project_page_url, notice: 'Проект успешно создан' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_client
    @clients = Client.order(:name)
    # respond_to do |format|
    #   format.json { head :no_content }
    # end
    # respond_to do |format|
    #   format.js {}
    # end
  end


  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    elgtn =  ProjectElongation.new(pe_params[:project_elongation])    
    elgtn.save if !elgtn.new_date.nil?

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_page_url, notice: 'Проект успешно сохранен' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
    # p @project
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to project_page_url, notice: 'Проект успешно удален' }
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

    def store_prj_path
      session[:last_projects_page] = request.url || projects_url if request.get?
    end



    def check_sum
      prms = ['price','price_2','price_real','price_2_real','sum','sum_2','sum_real','sum_2_real',
              'sum_total','sum_total_real','designer_price', 'designer_price_2','visualer_price',
              'visualer_sum','designer_sum',
              'sum_total_executor']
      prms.each do |p|
        project_params[p] = project_params[p].gsub!(' ','') if !project_params[p].nil?
        # p p,project_params[p]
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pe_params
      params.permit(:project_elongation => [:project_id,:new_date,:elongation_type_id] )
    end

    def client_params
      params.require(:client).permit(:name, :address, :phone, :email)
    end

    def project_params
      params.require(:project).permit(:client_id, :address, :owner_id, :executor_id, :designer_id, :visualer_id, :project_type_id,
        :date_start, :date_end_plan, :date_end_real, :number, :date_sign,
        :footage, :footage_2, :footage_real, :footage_2_real, :style_id,
        :sum, :sum_total, :sum_real, :price, :price_2, :price_real,  :sum_2, :sum_total_real, :sum_2_real, :price_2_real,
        :month_in_gift, :act, :delay_days,  :pstatus_id, :attention,
        :designer_price, :designer_price_2, :visualer_price, :days, 
        :designer_sum, :visualer_sum, :sum_total_executor, :sum_rest,
        :debt, :interest, :payd_q, :payd_full, :first_comment, :progress,
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
      Project.column_names.include?(params[:sort2]) ? params[:sort2] : "number"
    end

    def dir_2
      defaul_dir = sort_column =='number' ? "asc": "desc"
      %w[asc desc].include?(params[:dir2]) ? params[:dir2] : defaul_dir
    end

end
