class ClientsController < ApplicationController
  respond_to :html, :json
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  # GET /clients
  # GET /clients.json
  def index
   # @clients = Client.all
    # if !params[:search].nil?
    #   s = '%'+params[:search]+'%'
    #   @clients = Client.where('LOWER(name) like LOWER(?) or LOWER(address) like LOWER(?)',s,s).order(:name)
    # else
    #   @clients = Client.order(:name)
    # end

    @clients = Client.by_city(@main_city)
                    .by_search(params[:search])
                    .by_owner(current_user)
                    .order(:name)

    # if !current_user.has_role?(:manager)
    #   @clients = @clients.where('id in (?)', current_user.projects.pluck(:client_id))
    # end


  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @title = 'Просмотр клиента'
    respond_modal_with @client, location: root_path
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
    respond_modal_with @client, location: root_path
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to clients_url, notice: 'Клиент успешно обновлен.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    @client.update(client_params)
    # respond_to do |format|
    #   if 
    #     #format.html { redirect_to clients_url, notice: 'Client was successfully updated.' }
    #     # format.html { head :no_content }
    #     # format.json { render :show, status: :ok, location: @client }
    #   else
    #     # format.html { render :edit }
    #     # format.json { render json: @client.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :address, :phone, :email, :city_id,
                                      contacts_attributes: 
                                        [:id, :contact_kind_id, :contact_kind, :val, :who, :_destroy])
    end
end
