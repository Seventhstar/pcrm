FactoryBot.define do 
  array = ['Двери', 'Напольное покрытие', 'Потолки']

  factory :goodstype do
    sequence(:name) { |n| array[n-1] }
  end  
end