FactoryBot.define do 
  cities = ["SPB", "Moskow"]
  factory :city do 
    sequence(:name) { |n| cities[n-1] }
  end
end