class CommentsController < ApplicationController

  before_action :load_comment, only: [:destroy]
  respond_to :js, :json

  def destroy
    @comment.destroy
    # respond_to do |format|
    #   format.json do
    #     render js: { status: :ok }
    #   end
    # end
  end

  def read_comment
    prms = {comment_id: params[:id], user_id: current_user.id}
    cu = CommentUnread.where(prms)
    if cu.present? 
      cu.destroy_all
    else
      CommentUnread.create(prms)
    end
    # end
    respond_to do |format|
      format.json do
        render json: {status: :unprocessable_entity}
      end
    end

  end

  def create

    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      # render json: { status: :ok }
    else
      respond_to do |format|
        format.json do
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
  

  private
  def comment_params
    params.require(:comment).permit(:id,:comment, :owner_id, :owner_type)
  end
  def load_comment
    @comment = Comment.find(params[:id])
  end
end
