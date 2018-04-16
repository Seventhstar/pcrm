class ProviderManagersController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user

  respond_to :html, :json, :js

  def create
    respond_with (@pm = ProviderManager.create(pm_params))
  #    respond_to do |format|
  #       if @pm.save
  #         format.html { redirect_to absences_url, notice: 'Менеджер успешно создан.' }
  #         format.json { render json: @pm.errors, status: :ok, location: @pm }
  #       else
  #         format.html { render :nothing => true }
  #         format.json { render json: @pm.errors, status: :unprocessable_entity }
  #       end
  #     end 
  end

  def destroy
    respond_with @pm.destroy!
    # respond_to do |format|
    #   format.html { redirect_to '/providers/', notice: 'Менеджер успешно удален.' }
    #   format.json { head :no_content }
    # end
  end

  private

    def set_shop
      @pm = ProviderManager.find(params[:id])
    end

    def pm_params
      params.require(:manager).permit(:name, :phone, :email,:provider_id)
    end

end
