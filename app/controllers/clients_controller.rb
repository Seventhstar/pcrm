class ClientsController < ApplicationController
  before_action :logged_in_user
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @clients = Client.by_city(@main_city)
                    .by_search(params[:search])
                    .by_owner(current_user)
                    .order(:name)
    @json_data = []
    @columns = %w"name:ФИО address phone email"
    fields  = @columns

    @clients.each do |client| 
      h = {id: client.id, month: ''}

      fields.each do |col|
        c = col.include?(":") ? col.split(':')[0] : col
        h[c] = client[c]
        if c.end_with?("_id")
          n = c[0..-4]
          h[n] = client.try(n+"_name")
        end
      end

      h[:address] = client.projects.pluck(:address).join(', ')
      @json_data.push(h)
    end
  end

  def show
    @title = 'Просмотр клиента'
    respond_modal_with @client, location: root_path
  end

  def new
    @title = 'Создание клиента'
    @client = Client.new
    @owner  = @client
  end

  def edit
    @title = 'Редактирование клиента'
    respond_modal_with @client, location: root_path
  end

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

  def update
    @client.update(client_params)
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_client
      @client   = Client.find(params[:id])
      @contacts = @client.contacts.order(:created_at) if action_name != 'create' && action_name != 'new'
      @owner    = @client
    end

    def client_params
      params.require(:client).permit(:name, :address, :phone, :email, :city_id,
                                    contacts_attributes: [:id, :contact_kind_id, :contact_kind, :val, :who, :_destroy])
    end
end
