class ProjectTypesController < ApplicationController
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
