class LeadsController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction, :only_active

  # GET /leads
  # GET /leads.json
  def index

    if current_user.admin? 
      @leads_ = Lead.all 
    else
      @leads_ = current_user.leads 
    end


    if params[:only_active] == "true"
      @s_status_ids = Status.where(:actual => true) 
      @leads = @leads_.where(:status => @s_status_ids).order(sort_column)
    else
      @leads = @leads_.order(sort_column)
    end
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
    @comments = @lead.leads_comments.order('created_at desc')
    
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)
    @channels = Channel.all

    respond_to do |format|
      if @lead.save
        format.html { redirect_to leads_url, notice: 'Lead was successfully created.' }
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
        format.html { redirect_to leads_url, notice: 'Lead was successfully updated.' }
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
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
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
      params.require(:lead).permit(:info, :fio, :footage, :phone, :email, :channel_id, :status_id, :user_id, :status_date)
    end

  def sort_column
    Lead.column_names.include?(params[:sort]) ? params[:sort] : "status_date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def only_active
    %w[true nil].include?(params[:only_active]) ? params[:only_active] : "all"
  end
end
