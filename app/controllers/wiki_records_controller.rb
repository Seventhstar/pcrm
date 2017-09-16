class WikiRecordsController < ApplicationController
  before_action :set_wiki_record, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  # GET /wiki_records
  # GET /wiki_records.json
  def index
    @wiki_cats    = WikiCat.order(:name)
    @parent_id = params[:wiki_record_id]
    @parent_id = 0 if @parent_id.nil?
    params.delete_if{|k,v| v=='' || v=='0' }
    @wiki_record = WikiRecord.find(@parent_id) if @parent_id != 0 


    if current_user.admin? 
      @wiki_records = WikiRecord.where(:parent_id => @parent_id ).order(:name)
    else
      @wiki_records = WikiRecord.where(parent_id: @parent_id, admin: false).order(:name)
    end


    if !params[:wiki_cat_id].nil? && params[:wiki_cat_id]!=0
      @wiki_records = @wiki_records.where(wiki_cat_id: params[:wiki_cat_id])
    end


    if !params[:search].nil? && params[:search]!=""
      info =params[:search]
      @wiki_records = @wiki_records.where('LOWER(description) like LOWER(?) or LOWER(name) like LOWER(?) ','%'+info+'%','%'+info+'%')
    end

  end

  # GET /wiki_records/1
  # GET /wiki_records/1.json
  def show
    def_params
  end

  def def_params
    @wiki_folders = WikiRecord.where(:parent_id =>0)
    @wiki_cats    = WikiCat.order(:name)
  end

  # GET /wiki_records/new
  def new
    @wiki_record = WikiRecord.new
    def_params
    # @wiki_folders = WikiRecord.where(:parent_id =>0)
    # p "@wiki_folders #{@wiki_folders}"
  end

  # GET /wiki_records/1/edit
  def edit
    if !current_user.admin? 
      redirect_to wiki_records_url
    end
    def_params
    @files = @wiki_record.attachments.order(:name)
    @owner = @wiki_record
       
  end

  # POST /wiki_records
  # POST /wiki_records.json
  def create
    @wiki_record = WikiRecord.new(wiki_record_params)
    def_params
    respond_to do |format|
      if @wiki_record.save
        format.html { redirect_to wiki_records_url, notice: 'Знание успешно создано.' }
        format.json { render :show, status: :created, location: @wiki_record }
      else
        p "@wiki_record.errors #{@wiki_record.errors.full_messages}"
        format.html { redirect_to new_wiki_record_url }
        format.json { render json: @wiki_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wiki_records/1
  # PATCH/PUT /wiki_records/1.json
  def update
    respond_to do |format|
      if @wiki_record.update(wiki_record_params)
        format.html { redirect_to wiki_records_url, notice: 'Знание успешно обновлено.' }
        format.json { render :show, status: :ok, location: @wiki_record }
      else
        format.html { render :edit }
        format.json { render json: @wiki_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wiki_records/1
  # DELETE /wiki_records/1.json
  def destroy
    @wiki_record.destroy
    respond_to do |format|
      format.html { redirect_to wiki_records_url, notice: 'Знание успешно удалено.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki_record
      @wiki_record = WikiRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_record_params
      params.require(:wiki_record).permit(:name, :description, :parent_id, :admin, :wiki_cat_id)
    end
end
