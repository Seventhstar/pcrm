class WorksController < ApplicationController
  before_action :set_work, only: [:edit, :update]

  respond_to :html, :json

  def create
    respond_with (@pm = Work.create(work_params))
  end

  def edit

  end

  def update
    respond_to do |format|
      if @work.update(work_params)
        format.html { redirect_to '/options/works', notice: 'Работа успешно обновлена.' }
        format.json { render :edit, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_work
    @work = Work.find(params[:id])
  end

  def work_params
    params.require(:work).permit(:work_type_id, :name)
  end
end