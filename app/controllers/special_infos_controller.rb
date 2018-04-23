class SpecialInfosController < ApplicationController
  before_action :load_special_info, only: [:edit, :destroy]
  respond_to :js

  def index
  end

  def destroy
    respond_with(@special_info.destroy)
  end

  def create
    @special_info = SpecialInfo.new(si_params.merge(user_id: current_user.id))
    if @special_info.save 
      respond_with @special_info
    else
      respond_to do |format|
        format.json { render json: @special_info.errors.full_messages, status: :unprocessable_entity }
      end
    end 
  end

  private 

    def si_params
      params.require(:special_info).permit(:id, :content, :specialable_id, :specialable_type)
    end

    def load_special_info
      @special_info = SpecialInfo.find(params[:id])
    end
end
