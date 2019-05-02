FactoryBot.define do 
  factory :p_status do
    # actual {true}
    sequence(:name) { |n| "status_#{n}" }
  end
end