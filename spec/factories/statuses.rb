FactoryBot.define do 
  factory :status do
    actual {true}
    sequence(:name) { |n| "status_#{n}" }
  end
end