class CostingsController < ApplicationController
  before_action :set_costing, only: [:show, :edit, :update, :destroy]
  before_action :default_params, only: [:edit, :create, :update]
  include Sortable
  
  respond_to :html, :js

  def index
    sort_1 = "users.name"
    dir_2  = params[:dir2].nil? ? "asc" : params[:dir2]
    sort_2 = params[:sort2].nil? ? "created_at" : params[:sort2]

    @costings = Costing.order("user_id, #{sort_2} #{dir_2}")
    respond_with(@costings)
  end

  def show
    respond_with(@costing)
  end

  def new
    @costing = Costing.new
    default_params
    respond_with(@costing)
  end

  def edit
    @costings_rooms = @costing.costing_rooms
    # dew
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

    def default_params
      @users = User.order(:name)
      @costings_types = CostingsType.all
      @rooms = Room.all

      @costing.costings_type_id = 1 if @costing.costings_type_id.nil?
      @costing.date_create = Date.today if @costing.date_create.nil?

      # puts  @costing.to_json
      @works = Work.order(:name)
      # @works = RoomWork.joins([:work])
      #                 .select('room_works.*, works.name as work_name, user.name as user_name')
      #                 .map{ |e| { room: e.room_id,
      #                             id: e.work_id,
      #                             name: e.work_name}}
      #                 .group_by{ |i| i[:room] }
    end

    def costing_params
      params.require(:costing).permit(:project_id, :user_id, :project_address, 
                                      :costings_type_id, :date_create, room_ids: [],
                                       costing_works_attributes: [], 
                                       costing_rooms_attributes: [:id, :room_id])
    end

    def sort_column
    end

    def sort_2
      Costing.column_names.include?(params[:sort2]) ? params[:sort2] : "created_at"
    end

end
