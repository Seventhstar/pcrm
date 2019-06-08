class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :check_sum, only: [:create,:update]
  before_action :logged_in_user
  # GET /payments
  # GET /payments.json
  def index
    params.delete_if{|k,v| v=='' || v=='0' }
    @projects = Project.order(:address)
    @payments = Payment.all
    @only_actual = params[:only_actual].nil? ? true : params[:only_actual]=='true'
    all_ids = Payment.all.ids
    pt_ids = s_ids = pp_ids = prj_ids = a_ids =  all_ids
    if !params[:search].nil?
       _prj_ids = Project.where('LOWER(address) like LOWER(?)', '%'+params[:search]+'%').ids
       s_ids   = @payments.where(project_id: _prj_ids).ids
    end

    prj_ids = @payments.where(project_id: params[:payments_project_id]).ids if !params[:payments_project_id].nil?
    pp_ids = PaymentPurpose.find(params[:payments_purpose_id]).payments.ids if !params[:payments_purpose_id].nil?
    pt_ids = PaymentType.find(params[:payments_payment_type]).payments.ids if !params[:payments_payment_type].nil?
    if @only_actual
      a_ids = Payment.where('date > ?',(Date.today.end_of_month-2.month)).ids
    end

    ids = pt_ids & s_ids & pp_ids & prj_ids & a_ids
      
    @payments = @payments.where(id: ids).order(:date)
  end




  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
      @projects = Project.order(:address)
      @pp = PaymentPurpose.order(:id)
      @payment = Payment.new
      @date = Date.today.try('strftime',"%d.%m.%Y")
  end

  # GET /payments/1/edit
  def edit
      @projects = Project.order(:address)
      @pp = PaymentPurpose.order(:id)
      @date = @payment.date.try('strftime',"%d.%m.%Y")
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payments_url, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to payments_url, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end
    def check_sum
      payment_params[:sum] = payment_params[:sum].gsub!(' ','')
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:project_id, :user_id, :whom_id, :whom_type, :payment_type_id, :payment_purpose_id, :date, :sum, :verified, :description)
    end
end
