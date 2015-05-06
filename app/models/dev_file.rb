class DevFile < ActiveRecord::Base
 belongs_to :develop, foreign_key: :develop_id
end
