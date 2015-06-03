class LeadsController < ApplicationController
  respond_to :html, :json

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


    if sort_column == "status_date"
      query_str = Rails.env.production? ? "*, date_trunc('month', status_date) AS month" : "*, datetime(status_date, 'start of month') AS month "
      sort_1 = sort_column == 'status_date' ? 'month' : sort_column
    else
      query_str = Rails.env.production? ? "*, date_trunc('month', start_date) AS month" : "*, datetime(start_date, 'start of month') AS month "
      sort_1 = sort_column == 'start_date' ? 'month' : sort_column
    end

#    query_str = Rails.env.production? ? "*, date_trunc('month', start_date) AS month" : "*, datetime(start_date, 'start of month') AS month "
    
 #   sort_1 = sort_column == 'start_date' ? 'month' : sort_column

    if sort_column == "status_date" && !current_user.admin?
      @leads = current_user.ic_leads.select(query_str)
    else
      @leads = Lead.select(query_str)
    end
    
    if !params[:search].nil?
      info =params[:search]
      @leads = @leads.where('LOWER(info) like LOWER(?)','%'+info+'%')
    end

    if !params[:only_actual] || params[:only_actual] == "true"
      @s_status_ids = Status.where(:actual => true).ids
      @leads = @leads.where(:status => @s_status_ids)
    end

    #if params[:sort] == 'users.name'
    if params[:sort] == 'ic_users.name'
      sort_1 = "users.name"
      @leads = @leads.joins(:ic_user)
    end

    
    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", leads.created_at desc"

    puts sort_1 + ": sort_1 " + sort_direction + " :sort_direction, "+ sort_2  + " " + dir_2 

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

    @channels = Channel.all
    @statuses = Status.all
    @comments = @lead.comments.order('created_at asc')
    @files = @lead.files

    @history = get_history_with_files(@lead)
    @comm_height = 444
    respond_modal_with @lead, location: root_path
  end

  # GET /leads/new
  def new
    @lead = Lead.new
    @channels = Channel.all
    @statuses = Status.all
  end

  # GET /leads/1/edit
  def edit
    @channels = Channel.all
    @statuses = Status.all
    @comments = @lead.comments.order('created_at asc')
    @files    = @lead.files
    @comm_height = 390
    @history = get_history_with_files(@lead)
    @owner = @lead
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)
    @channels = Channel.all

    respond_to do |format|
      if @lead.save
       if params[:lead][:first_comment]
        comm = @lead.comments.new
        comm.comment = params[:lead][:first_comment]
        comm.user_id = params[:lead][:user_id]
        comm.save
       end
       format.html { redirect_to leads_page_url, notice: 'Лид успешно создан.'}
       format.json { render :show, status: :created, location: @lead }
      else
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
      params.require(:lead).permit(:info, :fio, :footage, :phone, :email, :address, :channel_id, 
                      :status_id, :user_id, :status_date,:start_date, :first_comment,:leads_ids, :ic_user_id)
    end

  def sort_column
    #default_column = current_user.admin? ? "status_date" : "month"
    default_column = "status_date"
    Lead.column_names.include?(params[:sort]) || params[:sort] == 'ic_users.name' ? params[:sort] : default_column
  end

  def sort_2
    Lead.column_names.include?(params[:sort2]) ? params[:sort2] : "status_date"
    #Lead.column_names.include?(params[:sort2]) ? params[:sort2] : "start_date"
  end

  def dir_2
    defaul_dir = sort_column =='status_date' ? "asc": "desc"
    %w[asc desc].include?(params[:dir2]) ? params[:dir2] : defaul_dir
  end


  def sort_direction
    defaul_dir = sort_column =='status_date' ? "asc": "desc"
    #puts %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
    #s
    %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
  end

  def only_actual
    %w[true false nil].include?(params[:only_actual]) ? params[:only_actual] : "all"
  end


end
