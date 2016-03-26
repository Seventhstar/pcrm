class AbsenceShopsController < ApplicationController
	before_action :set_shop, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user
  def create
		@as = AbsenceShop.new(as_params)
     respond_to do |format|
        if @as.save
          format.html { redirect_to absences_url, notice: 'Поставщик успешно создан.' }
          format.json { render json: @as.errors, status: :ok, location: @as }
        else
          format.html { render :nothing => true }
          format.json { render json: @as.errors, status: :unprocessable_entity }
        end
      end 
  end

  def destroy
    @as.destroy
    respond_to do |format|
      format.html { redirect_to '/absences/', notice: 'Поставщик успешно удален.' }
      format.json { head :no_content }
    end
  end

  private

    def set_shop
      @as = AbsenceShop.find(params[:id])
    end

    def as_params
      params.require(:shop).permit(:shop_id, :target_id, :absence_id )
    end
end
