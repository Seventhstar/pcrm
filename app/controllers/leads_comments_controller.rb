class LeadsCommentsController < ApplicationController
  before_action :set_leads_comment, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /leads_comments
  # GET /leads_comments.json
  def index
    @leads_comments = LeadsComment.all
  end

  # GET /leads_comments/1
  # GET /leads_comments/1.json
  def show
  end

  # GET /leads_comments/new
  def new
    @leads_comment = LeadsComment.new
  end

  # GET /leads_comments/1/edit
  def edit
  end

  # POST /leads_comments
  # POST /leads_comments.json
  def create
    @leads_comment = LeadsComment.new(leads_comment_params)

    respond_to do |format|
      if @leads_comment.save
        format.html { redirect_to @leads_comment, notice: 'Комментарий успешно создан.' }
        format.json { render :show, status: :created, location: @leads_comment }
      else
        format.html { render :new }
        format.json { render json: @leads_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leads_comments/1
  # PATCH/PUT /leads_comments/1.json
  def update
    respond_to do |format|
      if @leads_comment.update(leads_comment_params)
        format.html { redirect_to @leads_comment, notice: 'Комментарий успешно обновлен.' }
        format.json { render :show, status: :ok, location: @leads_comment }
      else
        format.html { render :edit }
        format.json { render json: @leads_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads_comments/1
  # DELETE /leads_comments/1.json
  def destroy
    @leads_comment.destroy
    respond_to do |format|
      format.html { redirect_to leads_comments_url, notice: 'Комментарий успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leads_comment
      @leads_comment = LeadsComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leads_comment_params
      params.require(:leads_comment).permit(:comment, :user_id, :lead_id)
    end
end
