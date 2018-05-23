class WorkLinkersController < ApplicationController
  before_action :set_work, only: :destroy
  before_action :logged_in_user

  respond_to :js

  def create
    respond_with (@work = WorkLinker.create(work_params))
  end

  def destroy
    respond_with @work.destroy
  end

  private

    def set_work
      @work = WorkLinker.find(params[:id])
    end

    def work_params
      params.require(:linked).permit(:work_id, :linked_work_id)
    end
end
