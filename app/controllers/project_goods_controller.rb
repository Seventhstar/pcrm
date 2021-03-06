class ProjectGoodsController < ApplicationController
  include ProjectsHelper
  include FileHelper
  include VueHelper
  include CommonHelper
  # require 'unicode'

  respond_to :html, :json
  before_action :check_params, only: [:create, :update]
  before_action :set_project_good, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction

  after_action :update_project_condition, only: [:create, :update]
  after_action :send_changeset_email, only: [:update, :create]

  respond_to :html, :json, :js

  def show
  end

  def index
    # params[:year] = Date.today.year if params[:year].nil? 
    prj_ids = []
    params.delete_if{|k,v| v=='' || v=='0' }

    @only_actual = params[:only_actual].present? ? params[:only_actual]=='true' : true
    @executors = User.actual.by_city(current_user.city)
    
    force_year = false
    force_executor = false

    if params[:executor_id].present?
      e_ids = Project.by_executor(params[:executor_id]) 
      force_executor = true
    end

    if @only_actual 
      act_ids = ProjectCondition.where(closed: false).pluck(:project_id)
    end

    @groupKey = sort_column
    @sort_column = sort_column
    clarify_params
    @opened = params[:cut]

    year = params[:year].try(:to_i)

    if year.present?
      query = {date_place: Date.new(year, 1, 1)..Date.new(year, 12, 31)} 
      prj_ids = ProjectGood.where(query).pluck(:project_id).uniq 
      force_year = true
    end

    if !current_user.has_role?(:manager)
      prj_ids = [] if prj_ids.nil?
      u_ids = Project.where(executor_id: current_user.id).pluck(:id) 
      prj_ids &= u_ids
      prj_ids = u_ids if prj_ids.empty?
      force_year = true
    end

    _prj_ids = Project.by_city(@city).pluck(:id) 
    prj_ids = prj_ids.length > 0 ? _prj_ids&prj_ids : _prj_ids

    @goods = ProjectGood.left_joins([:provider, :project, :currency])
            .joins('LEFT JOIN providers as order_providers ON project_goods.order_provider_id = order_providers.id ')
            .only_actual(act_ids, @only_actual)
            .by_executor(e_ids, force_executor)
            .by_project_ids(prj_ids, force_year)
            .currency(params[:currency_id])
            .good_state(params[:good_state])
            .select("project_goods.*, 
                      providers.name as provider_name, 
                      order_providers.name as order_provider_name,
                      currencies.short as currency_short,
                      projects.address as address")

    @goods_files = Attachment.secret(is_manager?).where(owner_type: 'ProjectGood', owner_id: @goods.ids)

    prj_ids = @goods.pluck(:project_id).uniq         

    @projects   = Project.where(id: prj_ids)
                        .left_joins(:condition)
                        .select("projects.*, project_conditions.closed as closed")

    @currencies = Currency.order(:id)
    @goodstypes = Goodstype.order(:id)

  end

  def new
    @prj_good = ProjectGood.new
    @prj_good.goodstype_id = params[:goodstype_id]
    @prj_good.project_id   = params[:project_id]
    @title = "Создание заказа (Для проекта: #{@prj_good.project.address})"
    @providers = Goodstype.find(params[:goodstype_id]).providers
    @goods_priorities = GoodsPriority.order(:id)
    @cur_id = params[:owner_id]
    @owner = @prj_good

    @file_cache = generate_cache_id
    respond_modal_with @prj_good, location: root_path
  end

  def create
    pg_params.delete :group
    @prj_good = ProjectGood.new(pg_params)
    @file_cache = pg_params[:file_cache]
    @cur_id = pg_params[:owner_id]
    if @prj_good.save
      update_cache_files(@prj_good, @file_cache)
      @new_attachments = for_vue(@prj_good.attachments, 'owner_name')
      respond_with @prj_good
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
      @group  = pg_params[:group]
      pg_params.delete :group
      @prj_good.update(pg_params)  
      # puts "@prj_good.attachments #{@prj_good.attachments}"
      respond_with @prj_good
  end

  def edit
    @title = 'Редактирование заказа'
    @providers = Goodstype.find(@prj_good.goodstype_id).providers
    @goods_priorities = GoodsPriority.order(:id)
    @owner = @prj_good
    @group = params[:group]  

    @cur_id = params[:owner_id]
    respond_modal_with @prj_good, location: root_path
  end


  private
    def update_project_condition
      project = @prj_good.project
      count = project.goods.count 
      fixed = project.goods.where(fixed: true).count

      pc = ProjectCondition.find_or_create_by(project_id: project.id)
      pc.closed = count == fixed
      pc.save
    end

    def check_params
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
                                  :fixed, :sum_supply, :project_id, :owner_id, 
                                  :order_name, :order_provider_id, :order_goods_priority_id,
                                  :order_delivery_time_id, :order_currency_id, :order_description,
                                  :goods_priority_id, :delivery_time_id, :group, :file_cache)
    end

    def send_changeset_email
      if action_name == 'create'
        ProjectGoodMailer.created_email(@prj_good, @current_user).deliver_now
      else
        ProjectGoodMailer.changeset_email(@prj_good, @current_user).deliver_now
      end
    end

  end
