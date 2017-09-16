class ProjectElongationsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user

  # respond_to :js
  def create
    # respond_with(ProjectElongation.create(pe_params))
    @pe = ProjectElongation.new(pe_params)
    @pe.save
    respond_to do |format|
      format.json { render json: @pe.errors, status: :ok }
      format.html { render :nothing => true }
    end
    # render nothing: true
     # respond_to do |format|
     #  # !@pe.new_date.nil? &&
     #    if @pe.save 
     #      # format.html { redirect_to absences_url, notice: 'Менеджер успешно создан.' }
     #      format.json { render json: @pe.errors, status: :ok, location: @pe }
     #    else
     #      # format.html { render :nothing => true }
     #      format.json { render json: @pe.errors, status: :unprocessable_entity }
     #    end
     #  end 
  end

  def destroy
    @pe.destroy
    respond_to do |format|
      format.html { redirect_to '/providers/', notice: 'Менеджер успешно удален.' }
      format.json { head :no_content }
    end
  end

   private

    def set_project
      @pe = ProjectElongation.find(params[:id])
    end

    def pe_params
      params.require(:project_elongation).permit(:new_date,:elongation_type_id,:project_id)
    end
end
