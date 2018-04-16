class ProjectElongationsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user

  respond_to :js
  # respond_to :js,:json
  def create
    if current_user.has_role?(:manager)
      respond_with (@pe = ProjectElongation.create(pe_params))      
    end
  end

  def destroy
    respond_with @pe.destroy!
  end

  private

  def set_project
    @pe = ProjectElongation.find(params[:id])
    @project = @pe.project
  end

  def pe_params
    params.require(:project_elongation).permit(:new_date, :elongation_type_id, :project_id)
  end
end
