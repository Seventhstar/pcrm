class Attachment < ActiveRecord::Base
 belongs_to :user
 belongs_to :owner, :polymorphic => true
 has_paper_trail
end
