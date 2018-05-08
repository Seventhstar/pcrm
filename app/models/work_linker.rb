class WorkLinker < ApplicationRecord
  belongs_to :work
  belongs_to :linked_work, class_name: 'Work'
end