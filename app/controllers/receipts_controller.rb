class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  # GET /receipts
  # GET /receipts.json
  def index
    
    @providers = Provider.order(:name)

    @param_provider = params[:receipt_provider]
    @param_provider = @param_provider.to_i if !@param_provider.nil?

    all_ids = Receipt.all.ids
    p_ids = s_ids = pt_ids = all_ids

    if ![nil,'','0','-1'].include? params[:receipt_provider] 
        p_ids = Provider.find(params[:receipt_provider]).receipts.ids
    elsif @param_provider == 0
        p_ids = Receipt.where(provider_id: 0).ids
    end

    if ![nil,''].include? params[:rcpt_search]
       prj_ids = Project.where('LOWER(address) like LOWER(?)', '%'+params[:rcpt_search]+'%').ids
       s_ids   = Receipt.where(project_id: prj_ids).ids
    end

    if ![nil,'','0'].include? params[:receipt_payment_type]
      pt_ids = PaymentType.find(params[:receipt_payment_type]).receipts.ids
    end

    ids = p_ids & s_ids & pt_ids
      
    @receipts = Receipt.where(:id => ids).order(:date)
    @sum = @receipts.sum(:sum)
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
    @projects =  Project.all
    @receipt_user = current_user
    @date = Date.today.try('strftime',"%d.%m.%Y")
  end

  # GET /receipts/1/edit
  def edit
    @projects =  Project.all
    @receipt_user = @receipt.user
    @date = @receipt.date.try('strftime',"%d.%m.%Y")
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to receipts_url, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to receipts_url, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:project_id, :user_id, :provider_id, :payment_type_id, :date, :sum, :description)
    end
end
