class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :check_sum, only: [:create,:update]

  # GET /receipts
  # GET /receipts.json
  def index
    params.delete_if{|k,v| v=='-1' } 
    @providers = Provider.order(:name)
    @projects  = Project.order(:address)
    @executors = User.where(:id => Project.uniq.pluck(:executor_id))
    @param_provider = params[:receipts_provider]
    @param_provider = @param_provider.to_i if !@param_provider.nil?

    all_ids = Receipt.all.ids
    p_ids = s_ids = pt_ids = prj_ids =  u_ids = all_ids

    @receipts = Receipt.select("receipts.*, date_trunc('month', date) AS month" )
    p "params[:receipts_provider]",params[:receipts_provider]
    #p oeo
    if ![nil,'','0'].include? params[:receipts_provider] 
        p_ids = Provider.find(params[:receipts_provider]).receipts.ids
    elsif @param_provider == 0
        p_ids = @receipts.where(provider_id: 0).ids
    end
    p p_ids

    if ![nil,''].include? params[:search]
       _prj_ids = Project.where('LOWER(address) like LOWER(?)', '%'+params[:search]+'%').ids
       s_ids   = @receipts.where(project_id: _prj_ids).ids
    end

    if ![nil,'','0'].include? params[:receipts_project_id]
       prj_ids   = @receipts.where(project_id: params[:receipts_project_id]).ids
    end

    if ![nil,'','0'].include? params[:receipts_payment_type]
      pt_ids = PaymentType.find(params[:receipts_payment_type]).receipts.ids
    end

    if ![nil,'','0'].include? params[:receipts_executor_id]
      _prj_ids = User.find(params[:receipts_executor_id]).projects.ids
      p _prj_ids
      u_ids   = @receipts.where(project_id: _prj_ids).ids
      p "u_ids",u_ids
    end

    ids = p_ids & s_ids & pt_ids & prj_ids & u_ids
      
    @receipts = @receipts.where(:id => ids).order(:date)
    #@sum = @receipts.sum(:sum)
  end

  def to_move
    @receipts = Receipt.where(paid: false).order(:date)
  end

  def to_update
    @receipts = Receipt.find(params[:receipts_ids])

    #Lead.where(id: params[:leads_ids]).update_all(user_id: params[:user_id])
    @receipts.each do |r|
       p = Payment.new
       p.date = DateTime.now
       p.project_id = r.project_id
       p.user = current_user
       p.whom_type = 'User'
       p.whom_id = r.project.executor_id
       p.payment_type_id = 1
       p.payment_purpose_id = 1
       p.sum = r.sum
       p.description = '# перенос из поступления'
       p.save
    end
     Receipt.where(id: params[:receipts_ids]).update_all(paid: true)
    redirect_to payments_url
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

    get_debt
  end

  # GET /receipts/1/edit
  def edit
    @projects =  Project.all
    @receipt_user = @receipt.user
    @date = @receipt.date.try('strftime',"%d.%m.%Y")

    get_debt
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to receipts_url, notice: 'Платеж успешно создан.' }
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
        format.html { redirect_to receipts_url, notice: 'Платеж успешно сохранен.' }
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
      format.html { redirect_to receipts_url, notice: 'Платеж успешно удален.' }
      format.json { head :no_content }
    end
  end

  private

    def get_debt
      #cl_payments = @receipt.project.receipts.where(provider_id: 0).order(:date)
      @cl_total = @receipt.all_payd
      @cl_debt  = @receipt.project.nil? ? 0 : @receipt.project.total - @receipt.all_payd 
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    def check_sum
      receipt_params[:sum] = receipt_params[:sum].gsub!(' ','')
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:project_id, :user_id, :provider_id, :payment_type_id, :date, :sum,:description, :receipts_ids)
    end
end
