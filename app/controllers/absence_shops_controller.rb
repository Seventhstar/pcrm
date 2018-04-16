class AbsenceShopsController < ApplicationController
	before_action :set_shop, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user

  respond_to :js

  def create
		respond_with(@shop = AbsenceShop.create(as_params))
  end

  def destroy
    respond_with @shop.destroy!
  end

  private
    def set_shop
      @shop = AbsenceShop.find(params[:id])
    end

    def as_params
      params.require(:absence_shop).permit(:shop_id, :target_id, :absence_id )
    end
end
