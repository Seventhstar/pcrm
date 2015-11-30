class WikiRecord < ActiveRecord::Base
  belongs_to :parent, class_name: "WikiRecord"
  has_many :children, class_name: "WikiRecord", foreign_key: "parent_id"
  has_many :attachments, :as => :owner
end