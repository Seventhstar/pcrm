class AbsenceReasonsController < ApplicationController
  before_action :set_absence_reason, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /absence_reasons
  # GET /absence_reasons.json
  def index
    @absence_reasons = AbsenceReason.all
    @absence_reason = AbsenceReason.new

    @items  = AbsenceReason.order(:name)  
    @item = AbsenceReason.new
  end

  # GET /absence_reasons/1
  # GET /absence_reasons/1.json
  def show
  end

  # GET /absence_reasons/new
  def new
    @absence_reason = AbsenceReason.new

  end

  # GET /absence_reasons/1/edit
  def edit

  end

  # POST /absence_reasons
  # POST /absence_reasons.json
  def create
    @absence_reason = AbsenceReason.new(absence_reason_params)

    respond_to do |format|
      if @absence_reason.save
        format.html { redirect_to '/options/absence_reasons', notice: 'Absence reason was successfully created.' }
        format.json { render :index, status: :created, location: @absence_reason }
      else
        format.html { render :new }
        format.json { render json: @absence_reason.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /absence_reasons/1
  # PATCH/PUT /absence_reasons/1.json
  def update
    respond_to do |format|
      if @absence_reason.update(absence_reason_params)
        format.html { redirect_to '/options/absence_reasons', notice: 'Absence reason was successfully updated.' }
        format.json { render :index, status: :ok, location: @absence_reason }
      else
        format.html { render :edit }
        format.json { render json: @absence_reason.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /absence_reasons/1
  # DELETE /absence_reasons/1.json
  def destroy
    @absence_reason.destroy
    respond_to do |format|
      format.html { redirect_to '/options/absence_reasons', notice: 'Absence reason was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_absence_reason
      @absence_reason = AbsenceReason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def absence_reason_params
      params.require(:absence_reason).permit(:name)
    end
end
