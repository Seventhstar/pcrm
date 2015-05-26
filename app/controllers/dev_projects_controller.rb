class DevProjectsController < ApplicationController
  before_action :set_dev_project, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /dev_projects
  # GET /dev_projects.json
  def index
    @dev_projects = DevProject.all
    @items = DevProject.order(:name)
    @item  = DevProject.new
  end

  # GET /dev_projects/1
  # GET /dev_projects/1.json
  def show
  end

  # GET /dev_projects/new
  def new
    @dev_project = DevProject.new
  end

  # GET /dev_projects/1/edit
  def edit
  end

  # POST /dev_projects
  # POST /dev_projects.json
  def create
    @dev_project = DevProject.new(dev_project_params)

    respond_to do |format|
      if @dev_project.save
        format.html { redirect_to '/options/dev_projects', notice: 'Dev project was successfully created.' }
        format.json { render :index, status: :created, location: @dev_project }
      else
        format.html { render :new }
        format.json { render json: @dev_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dev_projects/1
  # PATCH/PUT /dev_projects/1.json
  def update
    respond_to do |format|
      if @dev_project.update(dev_project_params)
        format.html { redirect_to '/options/dev_projects', notice: 'Dev project was successfully updated.' }
        format.json { render :show, status: :ok, location: @dev_project }
      else
        format.html { render :edit }
        format.json { render json: @dev_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dev_projects/1
  # DELETE /dev_projects/1.json
  def destroy
    @dev_project.destroy
    respond_to do |format|
      format.html { redirect_to '/options/dev_projects', notice: 'Dev project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dev_project
      @dev_project = DevProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dev_project_params
      params.require(:dev_project).permit(:name, :priority_id)
    end
end
