FactoryBot.define do 
  list = ["Встреча с заказчиком", "Встреча с подрядчиком", "Встреча с прорабом", "Замер"]
  factory :absence_target do 
    sequence(:name) { |n| list[n-1] }
  end
end