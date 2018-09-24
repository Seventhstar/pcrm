class AbsShopValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add('Магазин:','не указан') if record.shop_id.nil?
  end
end

class AbsenceShop < ActiveRecord::Base
  belongs_to :absence
  belongs_to :shop, class_name: "Provider", foreign_key: :target_id, optional: true
  belongs_to :target, class_name: "AbsenceShopTarget", foreign_key: :target_id
  
  validates :target, presence: true
  validates_with AbsShopValidator
  
  def shop_name  
    shop_id.to_i==-1 ? 'другой' : shop.try(:name) 
  end

  def target_name
    target.try(:name)
  end
  
end
