FactoryBot.define do 
  factory :channel do 
    sequence(:name) { |n| "channel_#{n}" }
  end
end