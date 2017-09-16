class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments/question_#{params['id']}"
  end

  def follow_all
    stream_from "comments"
  end
end
