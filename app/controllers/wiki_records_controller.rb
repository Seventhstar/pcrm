class WikiRecordsController < ApplicationController
  before_action :set_wiki_record, only: [:show, :edit, :update, :destroy]

  # GET /wiki_records
  # GET /wiki_records.json
  def index
    @parent_id = params[:wiki_record_id]
    @parent_id = 0 if @parent_id.nil?
    @wiki_records = WikiRecord.where(:parent_id =>@parent_id).order(:id)
  end

  # GET /wiki_records/1
  # GET /wiki_records/1.json
  def show
    @parent_id = params[:id]
    @parent_id = 0 if @parent_id.nil?
    p "show", @parent_id, params
    @wiki_records = WikiRecord.where(:parent_id =>@parent_id).order(:id)
  end

  # GET /wiki_records/new
  def new
    @wiki_record = WikiRecord.new
    @wiki_folders = WikiRecord.where(:parent_id =>0)
  end

  # GET /wiki_records/1/edit
  def edit
    @wiki_folders = WikiRecord.where(:parent_id =>0)
    @files = @wiki_record.attachments
    @owner = @wiki_record
  end

  # POST /wiki_records
  # POST /wiki_records.json
  def create
    @wiki_record = WikiRecord.new(wiki_record_params)

    respond_to do |format|
      if @wiki_record.save
        format.html { redirect_to wiki_records_url, notice: 'Wiki record was successfully created.' }
        format.json { render :show, status: :created, location: @wiki_record }
      else
        format.html { render :new }
        format.json { render json: @wiki_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wiki_records/1
  # PATCH/PUT /wiki_records/1.json
  def update
    respond_to do |format|
      if @wiki_record.update(wiki_record_params)
        format.html { redirect_to wiki_records_url, notice: 'Wiki record was successfully updated.' }
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
      format.html { redirect_to wiki_records_url, notice: 'Wiki record was successfully destroyed.' }
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
      params.require(:wiki_record).permit(:name, :description, :parent_id)
    end
end
