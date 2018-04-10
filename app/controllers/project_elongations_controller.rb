class ProjectElongationsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user

  # respond_to :js
  # respond_to :js,:json
  def create
    if current_user.has_role?(:manager)
      @pe = ProjectElongation.new(pe_params)
      if @pe.save 
      else
        respond_to do |format|
          format.json { render json: @pe.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @pe.destroy
    # respond_to do |format|
    #   format.html { redirect_to '/providers/', notice: 'Менеджер успешно удален.' }
    #   format.json { head :no_content }
    # end
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
