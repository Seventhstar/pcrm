class PaymentTypesController < ApplicationController
  before_action :set_payment_type, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

	def index
    @payment_types = PaymentType.all
    @items = PaymentType.order(:name)
    @item  = PaymentType.new      
    #puts "we in payment_type"
  end

  def show
  end

  def create
    @payment_type = PaymentType.new(payment_type_params)

    respond_to do |format|
      if @payment_type.save
        format.html { redirect_to '/options/payment_types', notice: 'payment_type was successfully created.' }
        format.json { render :index, status: :created, location: @payment_type }
      else
        format.html { render :new }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment_type.destroy
    respond_to do |format|
      format.html { redirect_to '/options/payment_types', notice: 'payment_type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_type
      @payment_type = PaymentType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_type_params
      params.require(:payment_type).permit(:name)
    end
end
