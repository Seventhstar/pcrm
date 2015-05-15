class LeadsController < ApplicationController

  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction, :only_actual
  helper_method :sort_2, :dir_2

  include LeadsHelper
  #before_action :store_location

  def index_leads_params

  end

  # GET /leads
  # GET /leads.json
  def index

    query_str = Rails.env.production? ? "*, date_trunc('month', start_date) AS month" : "*, datetime(start_date, 'start of month') AS month "
    @leads = current_user.admin? ? Lead.select(query_str) : current_user.leads.select(query_str)
    
    if !params[:search].nil?
      info =params[:search]
      @leads = @leads.where('LOWER(info) like LOWER(?)','%'+info+'%')
    end

    if !params[:only_actual] || params[:only_actual] == "true"
      @s_status_ids = Status.where(:actual => true).ids
      @leads = @leads.where(:status => @s_status_ids)
    end

    if params[:sort] == 'users.name'
      @leads = @leads.joins(:user)
    end

    sort_1 = sort_column=='start_date' ? 'month' : sort_column
    order = sort_1 + " " + sort_direction + ", "+ sort_2  + " " + dir_2 + ", leads.created_at desc"

    #puts sort_1 + ": sort_1 " + sort_direction + " :sort_direction, "+ sort_2  + " " + dir_2 

    @leads = @leads.order(order)

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
  end

  # GET /leads/new
  def new
    @lead = Lead.new
    @channels = Channel.all
    @statuses = Status.all
  end

  # GET /leads/1/edit
  def edit
    @channels = Channel.all
    @statuses = Status.all
    @comments = @lead.leads_comments.order('created_at asc')
    @lead_files = @lead.leads_files

    @history = get_history
    
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)
    @channels = Channel.all

    respond_to do |format|
      if @lead.save
       if params[:lead][:first_comment]
        comm = @lead.leads_comments.new
        comm.comment = params[:lead][:first_comment]
        comm.user_id = params[:lead][:user_id]
        comm.save
       end
       format.html { redirect_to leads_url, notice: 'Лид успешно создан.'}
       format.json { render :show, status: :created, location: @lead }
      else
       format.html { render :new }
       format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
     end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to leads_page_url, notice: 'Лид успешно обновлен.' }
        format.html { redirect_back_or leads_url }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
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
      params.require(:lead).permit(:info, :fio, :footage, :phone, :email, :address, :channel_id, 
                      :status_id, :user_id, :status_date,:start_date, :first_comment,:leads_ids, :ic_user_id)
    end

  def sort_column
    default_column = current_user.admin? ? "status_date" : "month"
    Lead.column_names.include?(params[:sort]) || params[:sort] == 'users.name' ? params[:sort] : default_column
  end

  def sort_2
    #Lead.column_names.include?(params[:sort]) ? params[:sort] : "status_date"
    Lead.column_names.include?(params[:sort2]) ? params[:sort2] : "start_date"
  end

  def dir_2
    %w[asc desc].include?(params[:dir2]) ? params[:dir2] : "desc"
  end


  def sort_direction
    defaul_dir = sort_column =='status_date' ? "asc": "desc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : defaul_dir
  end

  def only_actual
    %w[true false nil].include?(params[:only_actual]) ? params[:only_actual] : "all"
  end

  def get_history
    
    history = Hash.new
    # изменения в самом лиде
    @lead.versions.reverse.each do |version|
      if version[:event]!="create" && version != @lead.versions.first 
        author = find_version_author_name(version) 
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        changeset = version.changeset 
        ch = Hash.new
        changeset.keys.each_with_index do |k,index| 
          if k=="updated_at"
          elsif k=="channel_id"
            ch.store( index, {'field' => t(k), 'from' => channel_name(changeset[k][0]), 'to' => channel_name(changeset[k][1]) } )
          elsif k=="status_id"
            ch.store( index, {'field' => t(k), 'from' => status_name(changeset[k][0]), 'to' => status_name(changeset[k][1]) } )
          elsif k=="user_id" || k=="ic_user_id"
            ch.store( index, {'field' => t(k), 'from' => user_name(changeset[k][0]), 'to' => user_name(changeset[k][1]) } )
          else
            ch.store( index, {'field' => t(k), 'from' => changeset[k][0], 'to' => changeset[k][1] } )
          end
        end
        history.store( at.to_s, {'at' => at_hum,'type'=> 'ch','author' => author,'changeset' => ch})
      end
    end
    # созданные файлы
    @lead.leads_files.each do |file|
      ch = Hash.new
      file.versions.reverse.each do |version|
        at = version.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
        at_hum = version.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
        author = user_name(version.whodunnit)
        ch.store( index, {'file' =>  file.name} )
        history.store( at, {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch})
      end  
    end
    # удаленные файлы
    file_id = []
    deleted = PaperTrail::Version.where_object(lead_id: @lead.id)
    deleted.each_with_index do |file,index|
      ch = Hash.new  
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      author = user_name(file.whodunnit)
      file_id << file['item_id']
      f = file['object'].split(/\r?\n/)
      f.shift
      a = Hash.new
      f.each do |line| 
        b,c = line.chomp.split(/: /)
        a[b] = c
      end
      #at = a['created_at'].to_time.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      ch.store( index, {'file' =>  a['name']} )
      history.store( at, {'at' => at_hum,'type'=> 'del','author' => author,'changeset' => ch})
    end  
    
    # созданные и потом удаленные файлы
    created = PaperTrail::Version.where(:item_id => file_id, event: 'create', item_type: 'LeadsFile')
    created.each_with_index do |file,index|
      at = file.created_at.localtime.strftime("%Y.%m.%d %H:%M:%S") 
      at_hum = file.created_at.localtime.strftime("%d.%m.%Y %H:%M:%S") 
      ch = Hash.new  
      author = user_name(file.whodunnit)
      file_id << file['item_id']
      f = file['object_changes'].split(/\r?\n/)
      ch.store( index, {'file' =>  f[f.index('name:')+2][2..-1] } )
      history.store( at, {'at' => at_hum,'type'=> 'add','author' => author,'changeset' => ch})
    end  
    history.sort.reverse
  end

end
