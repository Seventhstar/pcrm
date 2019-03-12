class ProvidersController < ApplicationController
  respond_to :html, :json
  before_action :set_provider, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :logged_in_user

  include ProvidersHelper
  include CommonHelper
  
  # GET /providers
  # GET /providers.json
  def index

    clean_params

    @styles = Style.all
    @budgets = Budget.order(:name)
    @goodstypes = Goodstype.order(:priority, :name)
    @p_statuses = PStatus.order(:name)

    @param_style = params[:style]
    @param_budget = params[:budget]
    @param_goodstype = params[:goodstype]
    @param_p_status = params[:p_status]
    @param_p_status = 5 if @param_p_status.nil?

    @param_search = params[:search]
    @only_actual = !params[:only_actual] || params[:only_actual] == "true"

    all_ids = Provider.order(:name).ids
    # sp = all_ids
    sp,bp,gtp,ps,s_ids = all_ids,all_ids,all_ids,all_ids,all_ids

    # if params[:search].present?
    #   srch = "%#{params[:search]}%"
    #   s_ids = Provider.where('LOWER(name) like LOWER(?) 
    #                           or LOWER(address) like LOWER(?)',
    #                         srch,
    #                         srch).ids
    #   # puts "s_ids #{s_ids}"
    #   # dqhgg
    # end

    # if params[:style] && params[:style]!="" && params[:style]!='0'
    #      sp = Style.find(params[:style]).providers.ids
    # end

    # if params[:budget] && params[:budget]!="" && params[:budget]!='0'
    #     bp = Budget.find(params[:budget]).providers.ids
    # end

    if params[:goodstype] && params[:goodstype]!="" && params[:goodstype]!='0'
        gtp = Goodstype.find(params[:goodstype]).providers.ids

    # puts "@param_goodstype.present? #{@param_goodstype.present?} = #{@param_goodstype}"
    @goodstypes = [Goodstype.find(params[:goodstype])] if @param_goodstype.present?
    # puts "@goodstypes #{@goodstypes.count}"
    end

    # if  @only_actual
    #     ps = Provider.where('p_status_id > 2').ids
    # end

    # @ids = sp & bp & gtp & ps & s_ids

    # puts "@main_city #{@main_city}"
                          # .includes(:goodstypes)
                         # .joins(:provider_goodstypes)
                         # .by_budget(params[:budget])
                         # .by_style(params[:style])
    @providers = Provider.by_city(@main_city)
                         .only_actual(@only_actual)
                         .by_search(params[:search])
                         .by_pstatus(params[:p_status])
                         .by_goodstype(gtp)
                         .order(:name) # find(ids, :order => :name)
    @ids = @providers.ids
                         # .where(id: @ids)


    store_providers_path
    puts "params #{params}", @providers.count
  end

  # GET /providers/1
  # GET /providers/1.json
  def show
    @title = 'Просмотр поставщика'
    @owner = @provider
    # @comments = @provider.comments.order('created_at asc')
    # @owner = @provider
    @comm_height = 313
    respond_modal_with @lead, location: root_path
  end

  # GET /providers/new
  def new
    @provider = Provider.new
    @provider.p_status_id = 7 
    @managers = {}
    @manager  = ProviderManager.new
    @p_statuses = PStatus.order(:name)
    @provider.city_id = current_user.city_id
    @owner = @provider
  end

  # GET /providers/1/edit
  def edit
    @provider = Provider.find(params[:id])

    if current_user.has_role?(:manager)
      @positions = Position.order(:name)
      @managers  = @provider.provider_managers
    else
      @positions = Position.where(secret: false).order(:name)
      @managers  = @provider.provider_managers.where(position_id: @positions.ids)
    end
    
    @manager  = ProviderManager.new
    @p_statuses = PStatus.order(:name)

    @comm_height = 340
    # @comments = @provider.comments.order('created_at asc')
    @owner = @provider
  end

  # POST /providers
  # POST /providers.json
  def create
    @provider = Provider.new(provider_params)

    respond_to do |format|
      if @provider.save
        format.html { redirect_to providers_page_url, notice: 'Поставщик успешно создан.' }
        format.json { render :show, status: :created, location: @provider }
      else
        format.html { render :new }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1
  # PATCH/PUT /providers/1.json
  def update
    respond_to do |format|
      if @provider.update(provider_params)
      #@provider = Provider.find(params[:id])
      #if @provider.update_attributes(params[:provider])
        format.html { redirect_to providers_page_url, notice: 'Поставщик успешно обновлен.' }
        format.json { render :show, status: :ok, location: @provider }
      else
        format.html { render :edit }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /providers/1
  # DELETE /providers/1.json
  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_page_url, notice: 'Поставщик успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id]) if params[:id].present?
      @providers = Goodstype.find(params[:goodstype_id]).providers if params[:goodstype_id].present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit( :name, :manager, :phone, :komment, :address, 
                                        :email, :url, :spec, :p_status_id, :city_id,
        budget_ids: [], style_ids: [], goodstype_ids: [], 
  special_infos_attributes: [:id, :content, :_destroy])
    end

    def sort_column
      Provider.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
