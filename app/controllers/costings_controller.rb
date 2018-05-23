class CostingsController < ApplicationController
  before_action :set_costing, only: [:show, :edit, :update, :destroy]
  include Sortable
  
  respond_to :html

  def index
    @costings = Costing.all
    sort_1 = "users.name"
    sort_2 = "created_at"
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
    respond_with @costing, location: costings_path
  end

  def update
    @costing.update(costing_params)
    respond_with @costing, location: costings_path
  end

  def destroy
    @costing.destroy
    respond_with @costing, location: costings_path
  end

  private
    def set_costing
      @costing = Costing.find(params[:id])
    end

    def costing_params
      params.require(:costing).permit(:project_id, :user_id, :project_address, room_ids: [])
    end

    def sort_column
    end

    def sort_2
      Costing.column_names.include?(params[:sort2]) ? params[:sort2] : "created_at"
    end

end
