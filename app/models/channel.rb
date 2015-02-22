class Channel < ActiveRecord::Base
 has_many :leads
 validates :name, :length => { :minimum => 3 }
end
