class WikiRecord < ActiveRecord::Base
  belongs_to :wiki_cat, optional: true
  belongs_to :parent, class_name: "WikiRecord", optional: true
  has_many :children, class_name: "WikiRecord", foreign_key: "parent_id"
  has_many :attachments, as: :owner
  has_paper_trail

  scope :by_user, -> (is_manager){where(admin: false) if !is_manager}  
  scope :by_parent, -> (parent) {where(parent_id: parent) if parent.present?}
  scope :by_category, -> (category) {where(wiki_cat_id: category) if category.present?}

  scope :search, -> (keyword) {where('LOWER(description) like LOWER(?) or LOWER(name) like LOWER(?)', 
                                keyword, keyword) if keyword.present?}
end
