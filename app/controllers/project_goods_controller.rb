class ProjectGoodsController < ApplicationController
  include ProjectsHelper
  respond_to :html, :json
  before_action :check_sum, only: [:create, :update]
  before_action :set_project_good, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js

  def show
  end

  def index
    params.delete_if{|k,v| v=='' || v=='0' }
    
    @sort_column = sort_column
    @goods = ProjectGood.order(@sort_column)
    clarify_params

    case params[:good_state]
    when '1'
      @goods = @goods.where(order: false)
    when '2'
      @goods = @goods.where(order: true, fixed: false)
    when '3'
      @goods = @goods.where(fixed: true)
    end

  end

  def create
    @prj_good = ProjectGood.new(pg_params)
    # puts "prm: #{pg_params}"
    # @prj_good.project_id = params[:owner_id] #.split('_').last
    @cur_id = pg_params[:owner_id]
    if @prj_good.save
      respond_to do |format|
        format.json do
          render json: {
            head: :ok,
            saved: true,
            id: @prj_good.id
          }.to_json
        end
      end
    else
      respond_to do |format|
        format.json { render json: @prj_good.errors.full_messages, status: :unprocessable_entity }
      end
    end 
  end

  def destroy
    @prj_good.destroy
  end

  def update
    @cur_id = pg_params[:owner_id]
    @prj_good.update(pg_params)    
    respond_with @prj_good
  end

  def edit
    @title = 'Редактирование заказа'
    @providers = Goodstype.find(@prj_good.goodstype_id).providers
    puts "@prj_good", @prj_good.to_json, @providers.pluck(:id)
    @cur_id = params[:owner_id]
    respond_modal_with @prj_good, location: root_path
  end


  private

    def check_sum
      prms = [:gsum, :sum_supply]
      prms.each do |p|
        pg_params[p] = pg_params[p].gsub!(' ','') if !pg_params[p].nil?
      end
    end

    def sort_column
      default_column = "project_id"
      (ProjectGood.column_names.include?(params[:sort]) || params[:sort] == 'project_id' ) ? params[:sort] : default_column
    end

    def sort_direction
      defaul_dir = sort_column =='project_id' ? "asc": "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
    end


    def set_project_good
      @prj_good = ProjectGood.find(params[:id])
    end

    def pg_params
      first_param = params.permit!.to_h.first[0] 
      req = first_param == 'upd_modal' ? :upd_modal : :gt
      params.require(req).permit( :goodstype_id, :provider_id, :date_supply, :date_place, 
                                  :date_offer, :currency_id, :gsum, :order, :name, :description, 
                                  :fixed, :sum_supply, :project_id, :owner_id)
    end
  end
