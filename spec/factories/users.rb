FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.info"
  end

  factory :user do
    email
    name {"user_one"}
    city {City.first}
    password {'123456'}
    password_confirmation {'123456'}
    activated {true}
      
    factory :user_manager do 
      after(:create) do |user|
        create(:user_role, user: user, role_id: 3)
        create(:user_role, user: user, role_id: 1)
      end
    end
  end
end