class DevelopsFile < ActiveRecord::Base
 belongs_to :develop, foreign_key: :develop_id
 has_paper_trail
end
