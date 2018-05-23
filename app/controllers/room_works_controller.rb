class RoomWorksController < ApplicationController
  before_action :set_room, only: :destroy
  before_action :logged_in_user

  respond_to :js

  def create
    respond_with (@room_work = RoomWork.create(room_params))
  end

  def destroy
    respond_with @room_work.destroy
  end

  private

    def set_room
      @room_work = RoomWork.find(params[:id])
    end

    def room_params
      params.require(:room_work).permit(:work_id, :room_id)
    end
end
