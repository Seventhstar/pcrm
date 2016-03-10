class AbsenceTargetsController < ApplicationController
  before_action :set_absence_target, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /absence_targets
  # GET /absence_targets.json
  def index
    @absence_targets = AbsenceTarget.all
    @absence_target = AbsenceTarget.new

    @items  = AbsenceTarget.order(:name)  
    @item = AbsenceTarget.new
  end

  # GET /absence_targets/1
  # GET /absence_targets/1.json
  def show
  end

  # GET /absence_targets/new
  def new
    @absence_target = AbsenceTarget.new

  end

  # GET /absence_targets/1/edit
  def edit

  end

  # POST /absence_targets
  # POST /absence_targets.json
  def create
    @absence_target = AbsenceTarget.new(absence_target_params)

    respond_to do |format|
      if @absence_target.save
        format.html { redirect_to '/options/absence_targets', notice: 'Absence reason was successfully created.' }
        format.json { render :index, status: :created, location: @absence_target }
      else
        format.html { render :new }
        format.json { render json: @absence_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /absence_targets/1
  # PATCH/PUT /absence_targets/1.json
  def update
    respond_to do |format|
      if @absence_target.update(absence_target_params)
        format.html { redirect_to '/options/absence_targets', notice: 'Absence reason was successfully updated.' }
        format.json { render :index, status: :ok, location: @absence_target }
      else
        format.html { render :edit }
        format.json { render json: @absence_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /absence_targets/1
  # DELETE /absence_targets/1.json
  def destroy
    @absence_target.destroy
    respond_to do |format|
      format.html { redirect_to '/options/absence_targets', notice: 'Absence reason was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_absence_target
      @absence_target = AbsenceTarget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def absence_target_params
      params.require(:absence_target).permit(:name)
    end
end
