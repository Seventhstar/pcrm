class LeadsController < ApplicationController
  include LeadsHelper
  include CommonHelper
  include Sortable
  include Commentable

  before_action :logged_in_user
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_action :def_params, only: [:show, :edit, :new, :update]
  before_action :logged_in_user

  respond_to :html, :json

  def index_leads_params

  end

  # GET /leads
  # GET /leads.json
  def index
    # puts "@year #{@year}"
    # puts "@city #{@city}"
    # @years = (2016..Date.today.year).step(1).to_a.reverse
    @priorities = Priority.all
    @sort_column = sort_column

    @only_actual = params[:actual].present? ? params[:actual]=='true' : true
    # @only_actual = params[:only_actual].present? ? params[:only_actual]=='true' : true
    
    query_date  = @sort_column == "status_date" ? "status_date" : "start_date"
    sort_1      = @sort_column == query_date ? 'month' : @sort_column
    query_str   = "leads.*, date_trunc('month', #{query_date}) AS month"
    # query_str   = "*"
    
    includes = [:status]
    
    if current_user.has_role?(:manager)
      @leads = Lead.select(query_str)
      # puts "query_str #{query_str}, @only_actual #{@only_actual}"
    else
      if params[:sort] == 'users.name'
        @leads = current_user.leads.select(query_str)
      else
        @leads = current_user.ic_leads.select(query_str)
      end
    end

    # puts "@leads #{@leads.to_h}"

    # if params[:search].present?
    #   info = params[:search].downcase
    #   q = "%#{info}%"
    #   phone_q = "%#{info.gsub(/[-()+ .,]/,'')}%"

    #   @leads = @leads
    #     .where(%q{LOWER(info) like ?
    #       or LOWER(phone) like ? 
    #       or LOWER(fio) like ? 
    #       or LOWER(address) like ? 
    #       or LOWER(leads.email) like ?}, q, phone_q, q, q, q)
    # end

    if params[:sort] == 'ic_users.name'
      sort_1 = "users.name"
      includes << :ic_user
    elsif params[:sort] == 'users.name'
      sort_1 = "users.name"
      includes << :user     
    end

    puts "#{sort_1} #{sort_direction}, #{sort_2} #{dir_2}, leads.created_at desc"
    
    @leads = @leads
              .includes(includes)
              .by_city(@city)
              .by_priority(params[:priority_id])
              .by_year(params[:year])
              .order("leads.created_at desc")
              # .only_actual(@only_actual)
              # .order("#{sort_1} #{sort_direction}, #{sort_2} #{dir_2}, leads.created_at desc")

    # puts "leads #{@leads.length}"

    # columns = %w"status_id status_date fio phone info footage start_date"
    @columns = %w"status_id status_date fio phone info footage start_date:Дата"
    fields  = %w"user_id priority_id ic_user_id".concat(@columns)

    @json_data = []
      # map{ |l| columns.hash{ |c| l => l[c]
    @filterItems = %w'priority user'

    actual_statuses = Status.where(actual: true).ids
    # where(status_id: )

    @leads.each do |l| 
      h = {id: l.id, 
          month: year_month(l.start_date), 
          month_label: month_year(l.start_date), 
          status_month: month_year(l.status_date),
          class: class_for_lead(l),
          actual: actual_statuses.include?(l.status_id)
          }
          
      fields.each do |col|
        c = col.include?(":") ? col.split(':')[0] : col
        h[c] = l[c]
        if c.end_with?("_id")
          n = c[0..-4]
          h[n] = l.try(n+"_name")
        end
      end
      @json_data.push(h)
    end
    # wwekl
      # id: l.id,
      # status_id: l.status_id,
      # status: l.status_name,
      # status_date: format_date(l.status_date),
      # fio: l.fio,
      # phone: l.phone,
      # footage: l.footage,
      # address: l.address,
      # start_date: format_date(l.start_date),
      # info: l.info,
      # month: month_year(l.start_date)

    @users = User.actual.by_city(@city).order(:name)
    store_leads_path
  end

  def edit_multiple
    index
    @users = User.order(:name)
  end


  def update_multiple
    @leads = Lead.find(params[:leads_ids])

    Lead.where(id: params[:leads_ids]).update_all(user_id: params[:user_id])
    redirect_to leads_page_url
  end



  # GET /leads/1
  # GET /leads/1.json
  def show
    if !current_user.has_role?(:manager) and @lead.ic_user != current_user
      redirect_to leads_url
      return
    end
    @title = 'Просмотр лида'
    @comm_height = 488 #488
    respond_modal_with @lead, location: root_path
  end



  # GET /leads/new
  def new
    @lead = Lead.new
    @lead.start_date = Date.today.try('strftime',"%d.%m.%Y")
    @lead.status_id = 1
    @lead.ic_user_id = current_user.id
    @lead.channel_id = 1
    @lead.priority_id = 1
    @lead.city_id = current_user.city_id
  end

  # GET /leads/1/edit
  def edit
    if !current_user.has_role?(:manager) and @lead.ic_user != current_user
      redirect_to leads_url
      return
    end
    @comm_height = 482
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)
    @channels = Channel.all

    if @lead.save
      create_first_comment(@lead)
      respond_with @lead, location: -> { leads_page_url }
    else
      def_params
      respond_with @lead
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to leads_page_url, notice: 'Лид успешно обновлен.' }
      else
        def_params
        flash.now[:danger] = @lead.errors.full_messages
        format.html { render :edit }
      end
    end

  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_page_url, notice: 'Лид удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params[:lead][:phone] = params[:lead][:phone].gsub(/[-()+ .,]/,'')
      params.require(:lead).permit(:info, :fio, :footage, :phone, :email, :address, :channel_id, :source_id,
                      :status_id, :user_id, :status_date, :start_date, :first_comment, :leads_ids, :ic_user_id,
                      :priority_id, :city_id)
    end

    def flash_interpolation_options
        {resource_name: t("Lead")}
    end

    def def_params
      @channels = Channel.all
      @statuses = Status.all
      @owner    = @lead
      @history  = get_history_with_files(@lead)
      @priorities = Priority.all
      if @lead.present?
        @files    = @lead.attachments 
        @lead.priority_id = 1 if @lead.priority_id.nil?
      end
    end

    def sort_column
      default_column = "status_date"
      srt = params[:sort]
      (Lead.column_names.include?(srt) || srt == 'ic_users.name' || srt == 'users.name' ) ? srt : default_column
    end

    def sort_2
      Lead.column_names.include?(params[:sort2]) ? params[:sort2] : "status_date"
    end

    def sort_direction
      defaul_dir = sort_column == 'status_date' ? "asc": "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
    end

end
