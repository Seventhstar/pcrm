class Comment < ActiveRecord::Base
 belongs_to :user
 belongs_to :owner, :polymorphic => true
 has_many :receivers, class_name: 'CommentUnread', foreign_key: :comment_id

 def readed_by_user?(user)
  self.receivers.find_by_user_id(user.id).nil? 
 end

end
