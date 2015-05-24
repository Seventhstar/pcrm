class ProvidersController < ApplicationController
  respond_to :html, :json
  before_action :set_provider, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :logged_in_user
  # GET /providers
  # GET /providers.json
  def index
    @styles = Style.all
    @budgets = Budget.order(:name)
    @goodstypes = Goodstype.order(:name)
    @p_statuses = PStatus.order(:name)

    all_ids = Provider.order(:name).ids
    sp = all_ids
    bp = all_ids
    gtp = all_ids
    ps = all_ids

    
    if params[:style] && params[:style]!=""
        sp = Style.find(params[:style]).providers.ids
    end

    if params[:budget] && params[:budget]!=""
        bp = Budget.find(params[:budget]).providers.ids
    end

    if params[:goodstype] && params[:goodstype]!=""
        gtp = Goodstype.find(params[:goodstype]).providers.ids
    end

    if params[:p_status] && params[:p_status]!=""
        ps = PStatus.find(params[:p_status]).providers.ids
    end


    ids = sp & bp & gtp & ps
    #if ids.empty?
    #  @providers = @p.order(sort_column + " " + sort_direction) 
    #else 
      
    @providers = Provider.where(:id => ids).order(:name) # find(ids, :order => :name)
    #end
    #
    
  end

  # GET /providers/1
  # GET /providers/1.json
  def show    
    @title = 'Просмотр лида'
    respond_modal_with @lead, location: root_path
  end

  # GET /providers/new
  def new
    @provider = Provider.new
    @managers = {}
    @manager  = ProviderManager.new
    @p_statuses = PStatus.order(:name)
  end

  # GET /providers/1/edit
  def edit
    @provider = Provider.find(params[:id])
    @managers = @provider.provider_managers
    @manager  = ProviderManager.new
    @p_statuses = PStatus.order(:name)
    
    
  end

  # POST /providers
  # POST /providers.json
  def create
    @provider = Provider.new(provider_params)

    respond_to do |format|
      if @provider.save
        format.html { redirect_to providers_path, notice: 'Поставщик успешно создан.' }
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
      puts provider_params
      if @provider.update(provider_params)
      #@provider = Provider.find(params[:id])
      #if @provider.update_attributes(params[:provider])
        format.html { redirect_to providers_path, notice: 'Поставщик успешно обновлен.' }
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
      format.html { redirect_to providers_url, notice: 'Поставщик успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit(:name, :manager, :phone, :komment, :address, :email, :url, :spec, :p_status_id,:budget_ids =>[], :style_ids=>[], :goodstype_ids =>[] )
    end

  def sort_column
    Provider.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
