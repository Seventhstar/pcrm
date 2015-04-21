class DevelopsController < ApplicationController
  before_action :set_develop, only: [:show, :edit, :update, :destroy]
  helper_method :show_dev
  before_action :logged_in_user

  # GET /develops
  # GET /develops.json
  def index
    @develops = Develop.search(params[:search]).paginate(:page => params[:page], :per_page => 15)

    view = show_dev
    
    puts "show_dev: " + show_dev

    case view
    when "check"
      @develops = @develops.where(:boss => false, :coder =>true)      
    when "new"
      @develops = @develops.where(:boss => false, :coder =>false)      
    end
      
  end

  # GET /develops/1
  # GET /develops/1.json
  def show
  end

  # GET /develops/new
  def new
    @develop = Develop.new
  end

  # GET /develops/1/edit
  def edit
  end

  # POST /develops
  # POST /develops.json
  def create
    @develop = Develop.new(develop_params)

    respond_to do |format|
      if @develop.save
        format.html { redirect_to develops_path, notice: 'Задание на разработку успешно создано' }
        format.json { render :show, status: :created, location: @develop }
      else
        format.html { render :new }
        format.json { render json: @develop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /develops/1
  # PATCH/PUT /develops/1.json
  def update
    respond_to do |format|
      if @develop.update(develop_params)
        format.html { redirect_to develops_path, notice: 'Задание на разработку успешно обновлено.' }
        format.json { render :show, status: :ok, location: @develop }
      else
        format.html { render :edit }
        format.json { render json: @develop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /develops/1
  # DELETE /develops/1.json
  def destroy
    @develop.destroy
    respond_to do |format|
      format.html { redirect_to develops_url, notice: 'Задание на разработку успешно удалено.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_develop
      @develop = Develop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def develop_params
      params.require(:develop).permit(:name, :coder, :boss)
    end

    def show_dev
      %w[check new all].include?(params[:show]) ? params[:show] : "check"
    end
end 
