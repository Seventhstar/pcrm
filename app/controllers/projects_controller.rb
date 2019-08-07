class ProjectsController < ApplicationController
  include Sortable
  include Commentable
  include CommonHelper
  include ProjectsHelper

  before_action :logged_in_user
  before_action :check_sum,   only: [:create, :update]
  before_action :def_params,  only: [:new, :create, :edit, :update]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :update_client]
  
  respond_to :html, :json, :js

  def index
    @years = (2016..Date.today.year).step(1).to_a.reverse
    @executors = User.actual.by_city(current_user.city)

    @sort_column = sort_column
    sort_1 = @sort_column
    @numsort = (sort_1 == "number") 
    @only_actual = params[:only_actual].present? ? params[:only_actual]=='true' : true

    query_str = "projects.*, date_trunc('month', date_start) AS month" 
    @projects = current_user.has_role?(:manager) ? Project : current_user.projects
    @projects = @projects.select(query_str)

    @due_filters = [['Просроченные', 1], ['2 недели', 2], ['Этот месяц', 3]]

    includes = [:client, :elongations, :project_type, :pstatus]
    prjs_ids = nil

    if params[:due_filter].present?
      case params[:due_filter]
      when '1'
        prjs_ids = active_projects_before
      when '2'
        prjs_ids = active_projects_before(Date.today+14)
      when '3'
        prjs_ids = active_projects_before(Date.today.end_of_month+1)
      end 
    end

    if params[:search].present?
      src = "%#{params[:search]}%".mb_chars.downcase
      cl_ids = Client.where('LOWER(name) like ? or LOWER(email) like ? or LOWER(phone) like ?',src, src, src).pluck(:id)
      cl_prj = Project.where(client_id: cl_ids) 
      search_prj = @projects.where('LOWER(address) like ? or number = ?', src, params[:search].try('to_i')).pluck(:id)
      @projects = @projects.where(id: cl_prj + search_prj)
    end


    if params[:sort] == 'executor_id'
      sort_1 = "users.name"
      includes << :executor
    end

    @projects = @projects                
                .includes(includes)
                .only_actual(@only_actual)
                .by_city(@main_city)
                .by_executor(params[:executor_id])
                .by_year(params[:year])
                .by_ids(prjs_ids)
                .order("#{sort_1} #{sort_direction}, #{sort_2} #{dir_2}, projects.number desc")

    store_prj_path
    @sort = sort_1
  end

  # GET /projects/1
  # GET /projects/1.json
  def show

    respond_to do |format|
      # p "format #{format}"
      format.html do
        @title = 'Просмотр проекта'
        @owner = @project

        
        @comm_height = is_manager? ? 312 : 268

        respond_modal_with @project, location: root_path
        data = params[:data]
        get_debt(data) 
      end
      format.pdf do 
        pdf = ProjectPdf.new(@project) 
        send_data pdf.render, 
        filename: "Project_#{@project.id}.pdf",
        type: 'application/pdf',
        page_layout: 'landscape',
        disposition: 'inline'
      end

    end
  end

  def def_params
    @owner      = @project

    @styles     = Style.order(:name)
    @currencies = Currency.order('id')
    @pstatuses  = ProjectStatus.order(:name)
    @clients    = Client.where(city: @main_city).order(:name)
    @gtypes     = Goodstype.where(id: [@pgt_ids]).order(:priority)
    
    @tarifs     = Tarif.order(:project_type_id, :from)
    @holidays   = Holiday.pluck(:day).collect{|d| js_date(d)}
    @workdays   = WorkingDay.pluck(:day).collect{|d| js_date(d)}

    @project    = Project.new if @project.nil?


    @contacts   = @project.contacts.order(:created_at) if action_name != 'create' && action_name != 'new'

    @date_start = format_date(@project.date_start)
    @date_end   = format_date(@project.date_end)

    @executors  = User.actual.by_city(current_user.city)
    @visualers  = User.actual.by_city(current_user.city)
    @new_gtypes = Goodstype.where.not(id: [@pgt_ids]).order(:name)
    
    @project_types = ProjectType.order(:name)
    @goods_priorities = GoodsPriority.order(:id)

    @goods_states = [ {label: 'Предложенные', value: 1}, 
                      {label: 'Заказанные', value: 2}, 
                      {label: 'Закрытые', value: 3},
                      {label: 'Без файлов', value: 4} ]
  end

  # GET /projects/new
  def new
   
    @isNewProject = true

    @lead = params[:lead]
    if @lead.present?
      @lead = Lead.find(@lead)
      
      if @lead.present?
        @project.lead = @lead
        @address = @lead.address
        @client  = Client.find_by(name: @lead.fio)
        
        if @client.present?
          @toggled = true
        else
          @toggled = false
        end

        @client_name  = @lead.fio
        @phone        = @lead.phone
        @email        = @lead.email
      end
    end
    
    get_debt
    @city = current_user.city
    
    @date_start = format_date(Date.today)
    @date_end = format_date(Date.today)

    @project.city = current_user.city
    @owner  = @project
  end

  # GET /projects/1/edit
  def edit
    # puts "params #{params}"
    @isNewProject = false
    @tab = params[:tabs].try(:to_i)
    @gs = params[:good_state]

    if !@gs.nil? && @gs.to_i>0
      @gs = @gs.to_i
    else
      @gs = 0
    end

    get_debt
    @comm_height = 350
    @owner = @project
    @elongation_types = ElongationType.all
    @new_et  = ProjectElongation.new
    @new_gt  = Goodstype.new

    # @goods_sum = ProjectGood.where(project_id: @project.id)
    @goods = ProjectGood.where(project_id: @project.id)
            .left_joins(:provider)
            .left_joins(:goodstype)
            .left_joins(:currency)
            .select("project_goods.*, 
                      providers.name as provider_name, 
                      currencies.short as currency_short,
                      goodstypes.name as goodstype_name,
                      goodstypes.priority as goodstype_priority")
            .order('goodstypes.priority', :created_at)
            .except(:created_at, :updated_at)
            .group_by {|i| [i.goodstype_id, i.goodstype_name, i.goodstype_priority] }
            .map{ |g| g }
            
    used_pgt = @goods.map{|g| g[0][0]}
    # puts "used_pgt",used_pgt
    @pgt = Goodstype.where(default: true).pluck(:id, :name)
    @pgt_ids = @pgt.map{|p| p[0]}
    @pgt_ids = @pgt_ids | used_pgt
    # puts "@pgt_ids", @pgt_ids

    
    def_params

    @gtypes = @gtypes.to_a
    gtypes = @gtypes.clone

    gtypes.each do |gt|
      ind = used_pgt.index(gt.id)
      if ind.nil?
        @goods << [[gt.id, gt.name, gt.priority], []]
      else
        @gtypes.insert( ind, @gtypes.delete_at(@gtypes.index(gt)) )
      end
    end

    @goods.sort_by!{ |hsh| hsh[0][2] }
    @gtypes.sort_by!{ |hsh| hsh.priority }

    @providers = []
    @gtypes.each do |gt|
      @providers << { gt: gt, list: gt.providers.where('p_status_id > 2')
                                      .map{|p| {value: p.id, label: p.name, mark: p.p_status_id == 5}} }
    end

    # where(id: [pgt]).order(:name)

      @history  = get_history_with_files(@project)
    case @tab
    when 4
    #   # puts "@goods.count #{@goods.count}"
    when 6

      
    when 7
    else
      # @history = []
      # @files    = @project.attachments
      @files    = @project.attachments.secret(is_manager?).order(:created_at)
      @goods_files = Attachment.secret(is_manager?).where(owner_type: 'ProjectGood', owner_id: @project.goods.ids)
    end
    
  end

  # POST /projects
  # POST /projects.json
  def create
    pp = project_params
    pp['pstatus_id'] ||= 1
    @project = Project.new(pp)
    # ewkfjh
    cl_id = project_params[:client_id]
    if cl_id == "0" || cl_id.nil?
      @client = @project.create_client(client_params)
      @client.save
      @project.client_id = @client.id
    else
      @client = Client.find(cl_id)
    end

    respond_to do |format|
      if @project.save
        create_first_comment(@project)
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
  end

  def add_goodstype
    @project = Project.find(params[:g_type][:project_id])
    @pgt = params[:g_type][:g_type_id] 
    if @pgt.present? && @pgt.to_i >0 
      @prj_good_types = Goodstype.where(id: @pgt)
      def_params
    else
      respond_to do |format|
        format.json { render json: ['Выберите тип товара!'], status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    elgtn =  ProjectElongation.new(pe_params[:project_elongation])    
    elgtn.save if !elgtn.new_date.nil?

    respond_to do |format|
      if @project.update(project_params) && current_user.has_role?(:manager)
        format.html { redirect_to project_page_url, notice: 'Проект успешно сохранен' }
        format.json { render :show, status: :ok, location: @project }
      else
        edit
        flash.now[:danger] = @project.errors.full_messages
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if current_user.has_role?(:manager)
      @project.destroy 
      respond_to do |format|
        format.html { redirect_to project_page_url, notice: 'Проект успешно удален' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to project_page_url, notice: 'Нет прав для удаления проекта' }
      end
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
      prms = %w( price price_2 price_real price_2_real sum sum_2 sum_real sum_2_real
        sum_total sum_total_real designer_price designer_price_2 visualer_price
        visualer_sum designer_sum sum_total_executor)
      
      prms.each do |p|
        project_params[p] = project_params[p].gsub!(' ','') if !project_params[p].nil?
      end

      if !project_params[:progress].nil? && project_params["progress"].to_i>100
        project_params["progress"] = 100
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      # puts "id: #{params[:id]}, project_id: #{params[:project_id]}"
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pe_params
      params.permit(project_elongation: [:project_id, :new_date, :elongation_type_id] )
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
        :debt, :interest, :payd_q, :payd_full, :first_comment, :progress, :sum_discount, :discount,
        :city_id, :lead_id,
        client_attributes: [:name, :address, :phone, :email], 
        contacts_attributes: [:id, :contact_kind_id, :contact_kind, :val, :who, :_destroy],
        elongations_attributes: [:new_date, :elongation_type_id, :_destroy],
        special_infos_attributes: [:id, :content, :_destroy])
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

  end
