class AbsenceShop < ActiveRecord::Base
  belongs_to :absence
  belongs_to :shop, class_name: "Provider", foreign_key: :shop_id
  belongs_to :target, class_name: "AbsenceShopTarget", foreign_key: :target_id
  
  validates :target, presence: true
  
  def shop_name
    
    shop_id.to_i==0 ? 'другой' : shop.try(:name) 
  end

  def target_name
    target.try(:name)
  end
  
end
