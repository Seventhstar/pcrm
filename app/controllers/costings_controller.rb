class CostingsController < ApplicationController
  before_action :set_costing, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @costings = Costing.all
    respond_with(@costings)
  end

  def show
    respond_with(@costing)
  end

  def new
    @costing = Costing.new
    respond_with(@costing)
  end

  def edit
  end

  def create
    @costing = Costing.new(costing_params)
    @costing.save
    respond_with(@costing)
  end

  def update
    @costing.update(costing_params)
    respond_with(@costing)
  end

  def destroy
    @costing.destroy
    respond_with(@costing)
  end

  private
    def set_costing
      @costing = Costing.find(params[:id])
    end

    def costing_params
      params.require(:costing).permit(:project_id, :user_id, :project_address)
    end
end
