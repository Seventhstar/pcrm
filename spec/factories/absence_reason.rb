FactoryBot.define do 
  reasons = ["Прогул", "Выезд на объект", "Выезд в магазин", "Отпуск", "Больничный", "Личная причина"]
  factory :absence_reason do 
    sequence(:name) { |n| reasons[n-1] }
  end
end