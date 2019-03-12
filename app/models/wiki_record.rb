class WikiRecord < ActiveRecord::Base
  belongs_to :parent, class_name: "WikiRecord", optional: true
  belongs_to :wiki_cat, optional: true
  has_many :children, class_name: "WikiRecord", foreign_key: "parent_id"
  has_many :attachments, as: :owner
  has_paper_trail
end
