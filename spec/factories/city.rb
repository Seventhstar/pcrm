FactoryBot.define do 
  cities = ["Saint-Petersburg", "Moskow"]
  factory :city do 
    sequence(:name) { |n| cities[n-1] }
  end
end