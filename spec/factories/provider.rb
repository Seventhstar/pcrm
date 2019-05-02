FactoryBot.define do 
  list = ["Встреча с заказчиком", "Встреча с подрядчиком", "Встреча с прорабом", "Замер"]
  factory :provider do 
    sequence(:name) { |n| list[n-1] }
    association :p_status 
  end
end