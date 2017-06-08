class LeadsController < ApplicationController
  respond_to :html, :json
  before_action :logged_in_user

  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction, :only_actual
  helper_method :sort_2, :dir_2

  include LeadsHelper
  include CommonHelper
  #before_action :store_location

  def index_leads_params

  end

  # GET /leads
  # GET /leads.json
  def index

    years = Lead.select("leads.*, date_trunc('year', start_date) AS year").where('not start_date is null').order('start_date')
    year_from = years.first.year
    year_to = years.last.year

    @years = (year_from.year..year_to.year).step(1).to_a.reverse

    @only_actual = params[:only_actual].nil? ? true : params[:only_actual]=='true'
    @sort_column = sort_column
    if @sort_column == "status_date"
      query_str = "leads.*, date_trunc('month', status_date) AS month"
      sort_1 = @sort_column == 'status_date' ? 'month' : @sort_column
    else
      query_str = "leads.*, date_trunc('month', start_date) AS month"
      sort_1 = @sort_column == 'start_date' ? 'month' : @sort_column
    end
    
    # if @sort_column == "status_date" && !current_user.admin?
    if !current_user.admin?
      if params[:sort] == 'users.name'
        @leads = current_user.leads.select(query_str)
      else
        @leads = current_user.ic_leads.select(query_str)
      end
    else
      @leads = Lead.select(query_str)
    end
    
    if !params[:search].nil?
      info =params[:search]
      @leads = @leads.where('LOWER(info) like LOWER(?) or LOWER(phone) like LOWER(?) or LOWER(fio) like LOWER(?)','%'+info+'%','%'+info+'%','%'+info+'%')
    end

    if @only_actual
      @s_status_ids = Status.where(:actual => true).ids
      @leads = @leads.where(:status => @s_status_ids)
    end

    y = params[:year]
    if !y.nil? && y!='' && y.to_i>0
      @leads = @leads.where('EXTRACT(year FROM "start_date") = ?', y)
    end

    if params[:sort] == 'ic_users.name'
      sort_1 = "users.name"
       @leads = @leads.includes(:ic_user)
       # @leads = @leads.join('LEFT JOIN "users" u on lead.ic_user_id = u.id')
    elsif params[:sort] == 'users.name'
      sort_1 = "users.name"
      @leads = @leads.includes(:user)      
    end
    
    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", leads.created_at desc"
    @leads = @leads.order(order)
    store_leads_path
  end

  def edit_multiple
    index
    @users = User.order(:name)
  end


  def update_multiple
    @leads = Lead.find(params[:leads_ids])

    Lead.where(id: params[:leads_ids]).update_all(user_id: params[:user_id])
    redirect_to leads_page_url
  end



  # GET /leads/1
  # GET /leads/1.json
  def show
    @title = 'Просмотр лида'

    def_params

    @comm_height = 488
    respond_modal_with @lead, location: root_path
  end

  def def_params
    @channels = Channel.all
    @statuses = Status.all
    @owner    = @lead
    @files    = @lead.attachments
    @history  = get_history_with_files(@lead)
  end
  # GET /leads/new
  def new
    @lead = Lead.new
    @lead.start_date = Date.today
    @lead.status_id = 1
    @lead.ic_user_id = current_user.id
    @lead.channel_id = 1

    def_params
  end

  # GET /leads/1/edit
  def edit
    def_params
    @comm_height = 400
    
    
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)
    @channels = Channel.all

    respond_to do |format|
      if @lead.save
       if params[:lead][:first_comment] && !params[:lead][:first_comment].empty?
        comm = @lead.comments.new
        comm.comment = params[:lead][:first_comment]
        comm.user_id = params[:lead][:user_id]
        comm.save
       end
       format.html { redirect_to leads_page_url, notice: 'Лид успешно создан.'}
       format.json { render :show, status: :created, location: @lead }
      else
       def_params
       format.html { render :new }
       format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
     end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to leads_page_url, notice: 'Лид успешно обновлен.' }
#        format.html { redirect_back_or leads_url }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_page_url, notice: 'Лид удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:info, :fio, :footage, :phone, :email, :address, :channel_id, :source_id,
                      :status_id, :user_id, :status_date,:start_date, :first_comment,:leads_ids, :ic_user_id)
    end

  def sort_column
    default_column = "status_date"
    (Lead.column_names.include?(params[:sort]) || params[:sort] == 'ic_users.name' || params[:sort] == 'users.name' ) ? params[:sort] : default_column
  end

  def sort_2
    Lead.column_names.include?(params[:sort2]) ? params[:sort2] : "status_date"
  end

  def dir_2
    defaul_dir = sort_column =='status_date' ? "asc": "desc"
    %w[asc desc].include?(params[:dir2]) ? params[:dir2] : defaul_dir
  end


  def sort_direction
    defaul_dir = sort_column =='status_date' ? "asc": "desc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
  end

  def only_actual
    %w[true false nil].include?(params[:only_actual]) ? params[:only_actual] : "all"
  end


end
