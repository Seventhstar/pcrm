class ProviderManagersController < ApplicationController
	before_action :set_shop, only: [:show, :edit, :update, :destroy]  

  def create
    @pm = ProviderManager.new(pm_params)
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
    @pm.destroy
    respond_to do |format|
      format.html { redirect_to '/providers/', notice: 'Поставщик успешно удален.' }
      format.json { head :no_content }
    end
  end

  private

    def set_shop
      @pm = ProviderManager.find(params[:id])
    end

    def pm_params
      params.require(:shop).permit(:name, :phone, :email,:provider_id)
    end

end
