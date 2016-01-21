class ProviderManagersController < ApplicationController
	before_action :set_shop, only: [:show, :edit, :update, :destroy]  

  def create
    @pm = ProviderManager.new(pm_params)
     respond_to do |format|
        if @pm.save
          format.html { redirect_to absences_url, notice: 'Менеджер успешно создан.' }
          format.json { render json: @pm.errors, status: :ok, location: @pm }
        else
          format.html { render :nothing => true }
          format.json { render json: @pm.errors, status: :unprocessable_entity }
        end
      end 
  end

  def destroy
    @pm.destroy
    respond_to do |format|
      format.html { redirect_to '/providers/', notice: 'Менеджер успешно удален.' }
      format.json { head :no_content }
    end
  end

  private

    def set_shop
      @pm = ProviderManager.find(params[:id])
    end

    def pm_params
      params.require(:manager).permit(:name, :phone, :email,:provider_id)
    end

end
