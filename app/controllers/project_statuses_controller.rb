class ProjectStatusesController < ApplicationController
  before_action :set_project_status, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  
  def index
    @items = ProjectStatus.order(:name)
    @item  = ProjectStatus.new
  end

    def create
    @project_status = ProjectStatus.new(project_status_params)

    respond_to do |format|
      if @project_status.save
        format.html { redirect_to '/options/project_statuses', notice: 'Вид проекта успешно создан.' }
        format.json { render :index, status: :created, location: @project_status }
      else
        format.html { render :new }
        format.json { render json: @project_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def update
    respond_to do |format|
      if @project_status.update(project_status_params)
        format.html { redirect_to '/options/project_statuses', notice: 'project_status was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_status }
      else
        format.html { render :edit }
        format.json { render json: @project_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_status.destroy
    respond_to do |format|
      format.html { redirect_to '/options/project_statuses', notice: 'project_status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_type
      @project_status = ProjectStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_status_params
      params.require(:project_status).permit(:name)
    end
end
