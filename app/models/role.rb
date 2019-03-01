class Role < ActiveRecord::Base
  has_many :users, class_name: 'UserRole'
end
