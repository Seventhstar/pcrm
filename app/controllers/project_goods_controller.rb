class ProjectGoodsController < ApplicationController
  respond_to :html, :json
  before_action :set_project_good, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user
  before_action :check_sum, only: [:create,:update]
  helper_method :sort_column, :sort_direction

  def index

    years = Project.select("projects.*, date_trunc('year', date_start) AS year").where('date_start IS NOT NULL').order('date_start')
    year_from = years.first.year
    year_to = years.last.year
    @currency = 
    @years = (year_from.year..year_to.year).step(1).to_a.reverse
    
    @sort_column = sort_column
    # @goods = ProjectGood.order(@sort_column)
    @goods = ProjectGood.order(@sort_column)
  end

  def create

    @pg = ProjectGood.new(pg_params)
     respond_to do |format|
      # !@pg.new_date.nil? &&
        if @pg.save 
          format.html { redirect_to absences_url, notice: 'Менеджер успешно создан.' }
          format.json { render json: @pg.errors, status: :ok, location: @pg }
        else
          format.html { render :nothing => true }
          format.json { render json: @pg.errors, status: :unprocessable_entity }
        end
      end 
  end

  def destroy
    @pg.destroy
    respond_to do |format|
      format.html { redirect_to request.referer+'#tabs-4', notice: 'Позиция успешно удалена.' }
      format.json { head :no_content }
    end
  end

  def edit
    @title = 'Редактирование заказа'
    respond_modal_with @pg, location: root_path
  end


   private

   def check_sum
      p "check_sum"
      prms = ['gsum',:sum_supply]
      prms.each do |p|
        pg_params[p] = pg_params[p].gsub!(' ','') if !pg_params[p].nil?
        # p "check_sum",p,project_params[p]
      end
    end

    def sort_column
      default_column = "project_g_type_id"
      (ProjectGood.column_names.include?(params[:sort]) || params[:sort] == 'project_g_type_id' ) ? params[:sort] : default_column
    end

    def sort_direction
      defaul_dir = sort_column =='project_g_type_id' ? "asc": "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
    end


    def set_project_good
      @pg = ProjectGood.find(params[:id])
    end

    def pg_params
      prm = params.first[0] 
      params.require(prm).permit(:project_g_type_id,:provider_id,:date_supply,:date_place,:date_offer, 
        :currency_id,:gsum,:order,:name,:description, :fixed, :sum_supply)
    end
end
