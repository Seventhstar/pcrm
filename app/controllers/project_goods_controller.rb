class ProjectGoodsController < ApplicationController
  respond_to :html, :json
  before_action :set_project_good, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user
  before_action :check_sum, only: [:create,:update]
  helper_method :sort_column, :sort_direction

  respond_to :html, :json, :js

  def show
  end

  def index
    params.delete_if{|k,v| v=='' || v=='0' }
    years = Project.select("projects.*, date_trunc('year', date_start) AS year").where('date_start IS NOT NULL').order('date_start')
    year_from = years.first.year
    year_to = years.last.year

    @years = (year_from.year..year_to.year).step(1).to_a.reverse
    
    @sort_column = sort_column
    @goods = ProjectGood.order(@sort_column)

    if params[:currency]
      @goods = @goods.where(currency_id: params[:currency])
    end

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
    @prj_good.project_id = params[:owner_id].split('_').last
    p "@prj_good #{@prj_good}"
    if @prj_good.save 
      p "pg save" 
    else
    respond_to do |format|
      # !@prj_good.new_date.nil? &&
        # format.html { redirect_to absences_url, notice: 'Менеджер успешно создан.' }
        # format.json { render json: @prj_good.errors, status: :ok, location: @prj_good }
        # format.html { render nothing: true }
        format.json { render json: @prj_good.errors.full_messages, status: :unprocessable_entity }
      end
    end 
  end

  def destroy
    @prj_good.destroy
    # respond_to do |format|
    # #   format.html { redirect_to request.referer+'#tabs-4', notice: 'Позиция успешно удалена.' }
    #    format.js { head :no_content }
    # end
  end

  def update
    @prj_good.update(pg_params)    
    @prj_good.save 
    
  end

  def edit
    @title = 'Редактирование заказа'
    respond_modal_with @prj_good, location: root_path
  end


  private

  def check_sum
      # p "check_sum"
      #p "pg_params.sum_supply #{pg_params.sum_supply}"
      prms = [:gsum,:sum_supply]
      prms.each do |p|
        pg_params[p] = pg_params[p].gsub!(' ','') if !pg_params[p].nil?
      end

      # pg_params.sum_supply = pg_params.g_sum if pg_params.order && [0,nil,''].include?(pg_params.sum_supply)

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
      prm = params.permit!.to_h.first[0] 
      params.require(prm).permit(:goodstype_id,:provider_id,:date_supply,:date_place,:date_offer, 
        :currency_id,:gsum,:order,:name,:description, :fixed, :sum_supply, :project_id)
    end
  end
