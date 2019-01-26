FactoryBot.define do 
  factory :priority do
    sequence(:name) { |n| "priority_#{n}" }
  end
end