class ProjectTypesController < ApplicationController
	before_action :set_project_type, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  
  def index

		@items = ProjectType.order(:name)
		@item  = ProjectType.new
	end

	  def create
    @project_type = ProjectType.new(project_type_params)

    respond_to do |format|
      if @project_type.save
        format.html { redirect_to '/options/project_types', notice: 'Вид проекта успешно создан.' }
        format.json { render :index, status: :created, location: @project_type }
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
      if @project_type.update(project_type_params)
        format.html { redirect_to '/options/project_types', notice: 'project_type was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_type }
      else
        format.html { render :edit }
        format.json { render json: @project_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_type.destroy
    respond_to do |format|
      format.html { redirect_to '/options/project_types', notice: 'project_type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_type
      @project_type = ProjectType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_type_params
      params.require(:project_type).permit(:name)
    end
end
