class LeadsController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction, :only_actual
  helper_method :sort_2, :dir_2

  include LeadsHelper
  #before_action :store_location

  # GET /leads
  # GET /leads.json
  def index

    if current_user.admin? 
       if Rails.env.production?
          @leads = Lead.select("*, date_trunc('month', status_date) AS month")
       else
          @leads = Lead.select("*, datetime(status_date, 'start of month') AS month")
       end
    else
      @leads = current_user.leads.select("*, date_trunc('month', status_date) AS month")
    end

    if params[:search]
      info =params[:search]
      @leads = @leads.where('LOWER(info) like LOWER(?)','%'+info+'%')
    end

    sort_1 = sort_column=='status_date' ? 'month' : sort_column
    if !params[:only_actual] || params[:only_actual] == "true"
      @s_status_ids = Status.where(:actual => true) 
      @leads = @leads.where(:status => @s_status_ids)
    end

    @leads = @leads.order(sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2) #month desc +" " + dir_2
    #session[:last_leads_page] = request.url || leads_url    
    store_leads_path

    @channels = Channel.all
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
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
    @comments = @lead.leads_comments.order('created_at asc')
    @lead_files = @lead.leads_files
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)
    @channels = Channel.all

    respond_to do |format|
      if @lead.save
         if params[:lead][:first_comment]
            comm = @lead.leads_comments.new
	    comm.comment = params[:lead][:first_comment]
	    comm.user_id = params[:lead][:user_id]
            comm.save
	 end
	   STDERR.puts "params"
	   STDERR.puts params[:phone]
	   STDERR.puts params[:lead][:first_comment]
        format.html { redirect_to leads_url, notice: 'Лид успешно создан.'}
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
        format.html { redirect_back_or leads_url }
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
      format.html { redirect_to leads_url, notice: 'Лид удален.' }
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
      params.require(:lead).permit(:info, :fio, :footage, :phone, :email, :address, :channel_id, :status_id, :user_id, :status_date,:start_date, :first_comment)
    end

  def sort_column
    #Lead.column_names.include?(params[:sort]) ? params[:sort] : "status_date"
    Lead.column_names.include?(params[:sort]) ? params[:sort] : "month"
  end

  def sort_2
    #Lead.column_names.include?(params[:sort]) ? params[:sort] : "status_date"
    Lead.column_names.include?(params[:sort2]) ? params[:sort2] : "status_date"
  end

  def dir_2
    %w[asc desc].include?(params[:dir2]) ? params[:dir2] : "desc"
  end


  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def only_actual
    %w[true false nil].include?(params[:only_actual]) ? params[:only_actual] : "all"
  end
end
