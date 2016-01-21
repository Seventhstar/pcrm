class AbsenceShop < ActiveRecord::Base
  belongs_to :absence
  belongs_to :shop, class_name: "Provider", foreign_key: :shop_id
  belongs_to :target, class_name: "AbsenceShopTarget", foreign_key: :target_id
end
