class WikiRecord < ActiveRecord::Base
  belongs_to :parent, class_name: "WikiRecord"
  has_many :children, class_name: "WikiRecord", foreign_key: "parent_id"
  has_many :files, class_name: 'WikiFile'
end
