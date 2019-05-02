FactoryBot.define do 
  targets = ["Подбор", "Корректировка", "Заказ"]
  factory :absence_shop_target do 
    sequence(:name) { |n| targets[n-1] }
  end
end