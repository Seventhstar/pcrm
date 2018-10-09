class AbsenceShop < ActiveRecord::Base
  belongs_to :absence, optional: true
  belongs_to :shop, class_name: "Provider", foreign_key: :shop_id, optional: true
  belongs_to :target, class_name: "AbsenceShopTarget", foreign_key: :target_id
  
  validates :target, presence: true
  
  def shop_name  
    shop_id.to_i==-1 ? 'другой' : shop.try(:name) 
  end

  def target_name
    target.try(:name)
  end
  
end
