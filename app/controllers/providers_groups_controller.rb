class ProvidersGroupsController < ApplicationController
  respond_to :html, :json
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  def new
    @providers_group = ProvidersGroup.new
  end

  # GET /providers_groups/1/edit
  def edit
    respond_modal_with @providers_group, location: root_path
  end

  # POST /providers_groups
  # POST /providers_groups.json
  def create
    @providers_group = ProvidersGroup.new(providers_group_params)

    respond_to do |format|
      if @providers_group.save
        format.html { redirect_to providers_groups_url, notice: 'Клиент успешно обновлен.' }
        format.json { render :show, status: :created, location: @providers_group }
      else
        format.html { render :new }
        format.json { render json: @providers_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @providers_group.update(providers_group_params)
  end

  def destroy
    @providers_group.destroy
    respond_to do |format|
      format.html { redirect_to providers_groups_url, notice: 'ProvidersGroup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @providers_group = ProvidersGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def providers_group_params
      params.require(:providers_group).permit(:name, :spec, goodstype_ids: [])
    end
end
