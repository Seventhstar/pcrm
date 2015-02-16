class DevelopsController < ApplicationController
  before_action :set_develop, only: [:show, :edit, :update, :destroy]

  # GET /develops
  # GET /develops.json
  def index
    @develops = Develop.all
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
        format.html { redirect_to develops_path, notice: 'Develop was successfully created.' }
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
        format.html { redirect_to develops_path, notice: 'Develop was successfully updated.' }
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
      format.html { redirect_to develops_url, notice: 'Develop was successfully destroyed.' }
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
end
