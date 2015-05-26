class PStatusesController < ApplicationController
  before_action :set_p_status, only: [:show, :edit, :update, :destroy]

  # GET /p_statuses
  # GET /p_statuses.json
  def index
    @p_statuses = PStatus.all
    @items  = PStatus.order(:name)  
    @item = PStatus.new
    format.json { render :content_type => 'text/javascript' }
  end

  # GET /p_statuses/1
  # GET /p_statuses/1.json
  def show
  end

  # GET /p_statuses/new
  def new
    @p_status = PStatus.new
  end

  # GET /p_statuses/1/edit
  def edit
  end

  # POST /p_statuses
  # POST /p_statuses.json
  def create
    @p_status = PStatus.new(p_status_params)

    respond_to do |format|
      if @p_status.save
        format.html { redirect_to '/options/p_statuses', notice: 'P status was successfully created.' }
        format.json { render :index, status: :created, location: @p_status }
      else
        format.html { render :new }
        format.json { render json: @p_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /p_statuses/1
  # PATCH/PUT /p_statuses/1.json
  def update
    respond_to do |format|
      if @p_status.update(p_status_params)
        format.html { redirect_to '/options/p_statuses', notice: 'P status was successfully updated.' }
        format.json { render :index, status: :ok, location: @p_status }
      else
        format.html { render :edit }
        format.json { render json: @p_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /p_statuses/1
  # DELETE /p_statuses/1.json
  def destroy
    @p_status.destroy
    respond_to do |format|
      format.html { redirect_to '/options/p_statuses', notice: 'P status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_p_status
      @p_status = PStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def p_status_params
      params.require(:p_status).permit(:name)
    end
end
