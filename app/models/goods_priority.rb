class GoodsPriority < ApplicationRecord
  has_many :goods, class_name: 'ProjectGood'
end

