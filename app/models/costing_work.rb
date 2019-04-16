class CostingWork < ApplicationRecord
  belongs_to :costing
  belongs_to :work
  belongs_to :room

  def work_name
    work.try(:name)
  end

  def work_uom_name
    work&.uom&.name
  end
end
