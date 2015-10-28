class WikiFile < ActiveRecord::Base
 belongs_to :user
 belongs_to :wiki_record
 has_paper_trail
end
