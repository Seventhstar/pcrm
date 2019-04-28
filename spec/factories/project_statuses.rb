FactoryBot.define do 
  array = ['В работе', 'Приостановлен', 'Завершен']

  factory :project_status do
    sequence(:name) { |n| array[n-1] }
  end  
end