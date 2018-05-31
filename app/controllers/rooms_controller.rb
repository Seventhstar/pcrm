class RoomsController < ApplicationController
  before_action :set_room, only: [:edit, :update, :destroy]

  respond_to :html, :json

  def create
    respond_with (@room = Room.create(room_params))
  end

  def destroy
    respond_with @room.destroy, location: '/options/rooms'
  end
  
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to '/options/rooms', notice: 'Помещение успешно обновлена.' }
        format.json { render :edit, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
