class DevStatusesController < ApplicationController
  before_action :set_dev_status, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /dev_statuses
  # GET /dev_statuses.json
  def index
    @dev_statuses = DevStatus.all
    @items = DevStatus.order(:name)
    @item  = DevStatus.new
  end

  # GET /dev_statuses/1
  # GET /dev_statuses/1.json
  def show
  end

  # GET /dev_statuses/new
  def new
    @dev_status = DevStatus.new
  end

  # GET /dev_statuses/1/edit
  def edit
  end

  # POST /dev_statuses
  # POST /dev_statuses.json
  def create
    @dev_status = DevStatus.new(dev_status_params)

    respond_to do |format|
      if @dev_status.save
        format.html { redirect_to '/options/dev_statuses', notice: 'Dev status was successfully created.' }
        format.json { render :index, status: :created, location: @dev_status }
      else
        format.html { render :new }
        format.json { render json: @dev_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dev_statuses/1
  # PATCH/PUT /dev_statuses/1.json
  def update
    respond_to do |format|
      if @dev_status.update(dev_status_params)
        format.html { redirect_to '/options/dev_statuses', notice: 'Dev status was successfully updated.' }
        format.json { render :show, status: :ok, location: @dev_status }
      else
        format.html { render :edit }
        format.json { render json: @dev_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dev_statuses/1
  # DELETE /dev_statuses/1.json
  def destroy
    @dev_status.destroy
    respond_to do |format|
      format.html { redirect_to '/options/dev_statuses', notice: 'Dev status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dev_status
      @dev_status = DevStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dev_status_params
      params.require(:dev_status).permit(:name, :priority_id)
    end
end
