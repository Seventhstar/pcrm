FactoryBot.define do 
  
  sequence :address do |n|
     "prj_address_#{n}"
  end

  factory :project do
    address
    client
    pstatus ProjectStatus.first
    association executor
  end
  
end