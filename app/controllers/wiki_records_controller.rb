class WikiRecordsController < ApplicationController
  before_action :set_wiki_record, only: [:show, :edit, :update, :destroy]
  before_action :def_params, only: [:new, :create, :edit, :update, :show] 
  before_action :logged_in_user

  include CommonHelper
  
  # GET /wiki_records
  # GET /wiki_records.json
  def index
    @wiki_cats = WikiCat.order(:name)
    
    clean_params

    @parent_id = params[:wiki_record_id] 
    @keyword   = params[:search]

    if @keyword.nil?
      @parent_id ||= 0 
      @wiki_record = WikiRecord.find(@parent_id) if @parent_id != 0 
    end

    @wiki_records = WikiRecord.by_user(is_manager?)
                              .by_parent(@parent_id)
                              .by_category(params[:wiki_cat_id])
                              .search("%#{@keyword}%")
                              .order(:name) 
  end

  def def_params
    @wiki_folders = WikiRecord.where(parent_id: 0)
    @wiki_cats    = WikiCat.order(:name)
  end

  # GET /wiki_records/new
  def new
    @wiki_record = WikiRecord.new
  end

  # GET /wiki_records/1/edit
  def edit 
    redirect_to wiki_records_url if !current_user.has_role?(:manager)

    @files = @wiki_record.attachments.order(:name)
    @owner = @wiki_record
  end

  # POST /wiki_records
  # POST /wiki_records.json
  def create
    @wiki_record = WikiRecord.new(wiki_record_params)
    respond_to do |format|
      if @wiki_record.save
        format.html { redirect_to wiki_records_url, notice: 'Знание успешно создано.' }
        format.json { render :show, status: :created, location: @wiki_record }
      else
        # p "@wiki_record.errors #{@wiki_record.errors.full_messages}"
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
