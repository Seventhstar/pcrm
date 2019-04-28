FactoryBot.define do 
  
  sequence :address do |n|
     "ул. Такая-то дом.#{n}"
  end

  factory :project do
    address
    association :client
    # name {'wekfj'}
    association :project_type
    association :pstatus, factory: :project_status
    association :executor, factory: :user
  end
  
end