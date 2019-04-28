FactoryBot.define do 
  targets = ["Встреча с заказчиком", "Встреча с подрядчиком", "Встреча с прорабом", "Замер"]
  factory :absence_target do 
    sequence(:name) { |n| targets[n-1] }
  end
end