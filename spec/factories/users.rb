FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.info"
  end

  factory :user do
    email
    name "wuehf"
    city
    password '123456'
    password_confirmation '123456'
    activated true
  end
end