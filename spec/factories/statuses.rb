FactoryBot.define do 
  sequence :name do |n|
    "status_#{n}"
  end

  factory :status do
    name
    actual true
  end
  
end