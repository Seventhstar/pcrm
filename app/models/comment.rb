class Comment < ActiveRecord::Base
 belongs_to :user
 belongs_to :owner, :polymorphic => true
 has_many :receivers, class_name: 'CommentUnread', foreign_key: :comment_id
end
