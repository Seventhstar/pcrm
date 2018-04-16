class ProviderManagersController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user

  respond_to :html, :json, :js

  def create
    respond_with (@pm = ProviderManager.create(pm_params))
  end

  def destroy
    respond_with @pm.destroy!
  end

  private

    def set_shop
      @pm = ProviderManager.find(params[:id])
    end

    def pm_params
      params.require(:manager).permit(:name, :phone, :email,:provider_id)
    end

end
