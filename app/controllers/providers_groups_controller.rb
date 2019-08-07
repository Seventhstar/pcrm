class ProvidersGroupsController < ApplicationController
  respond_to :html, :json
  before_action :set_provider, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :logged_in_user

  include ProvidersHelper
  include CommonHelper
  
  # GET /providers
  # GET /providers.json
  def index
    @groups_with_el = Provider.pluck(:group_id).uniq - [nil, 0]
    
    @groups = Provider.where(is_group: true).order(:name).map{|g| {
      id: g.id, 
      name: g.name,
      spec: g.spec,
      allow_delete: !@groups_with_el.include?(g.id),
      goods_types_array: g.goods_type_names_array.join(', ')
    }}

    store_providers_path
  end

  def show
    @title = 'Просмотр поставщика'
    @owner = @provider
    # @comments = @provider.comments.order('created_at asc')
    # @owner = @provider
    @comm_height = 313
    respond_modal_with @lead, location: root_path
  end

  def new
    @provider = Provider.new
    @provider.p_status_id = 7 
    @provider.is_group = true
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
    # puts "provider_params #{provider_params}"
    @provider = Provider.new(check_params)
    respond_to do |format|
      if @provider.save
        format.html { redirect_to providers_page_url, notice: 'Поставщик успешно создан.' }
        format.json { render :show, status: :created, location: @provider }
      else
        # puts "@provider.errors #{@provider.errors.full_messages}"
        # puts "@provider #{@provider.to_json}"
        format.html { render :new }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1
  # PATCH/PUT /providers/1.json
  def update
    respond_to do |format|
      if @provider.update(check_params)
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
    def check_params
      # provider_params[:goodstype_ids] = provider_params[:goodstype_ids].reject(&:empty?)
      provider_params[:providers_group_id]=="0" ? provider_params.except(:providers_group_id) : provider_params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id]) if params[:id].present?
      @providers = Goodstype.find(params[:goodstype_id]).providers if params[:goodstype_id].present?
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit( :name, :manager, :phone, :komment, :address, 
                                        :email, :url, :spec, :p_status_id, :city_id,
                                        :providers_group_id, :is_group, :group_id,
                                        budget_ids: [], style_ids: [], 
                                        goodstype_ids: [], 
                                        special_infos_attributes: [:id, :content, :_destroy])
                                        # goodstype_attributes: [],
    end

    def sort_column
      Provider.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
