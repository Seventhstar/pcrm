class PaymentPurposesController < ApplicationController
	before_action :set_payment_purpose, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  def index
    @payment_purposes = PaymentPurpose.all
    @items = PaymentPurpose.order(:name)
    @item  = PaymentPurpose.new      
    #puts "we in payment_purpose"
  end

  def show
  end

  def create
    @payment_purpose = PaymentPurpose.new(payment_purpose_params)

    respond_to do |format|
      if @payment_purpose.save
        format.html { redirect_to '/options/payment_purposes', notice: 'payment_purpose was successfully created.' }
        format.json { render :index, status: :created, location: @payment_purpose }
      else
        format.html { render :new }
        format.json { render json: @payment_purpose.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment_purpose.update(payment_purpose_params)
        format.html { redirect_to '/options/payment_purposes', notice: 'payment_purpose was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_purpose }
      else
        format.html { render :edit }
        format.json { render json: @payment_purpose.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment_purpose.destroy
    respond_to do |format|
      format.html { redirect_to '/options/payment_purposes', notice: 'payment_purpose was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_purpose
      @payment_purpose = PaymentPurpose.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_purpose_params
      params.require(:payment_purpose).permit(:name)
    end
end
