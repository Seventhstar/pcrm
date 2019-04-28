FactoryBot.define do
  factory :role

  # sequence(:role) { |n| "role#{n}" }

  factory :user_role do
    # role_id {3
    association :user
    association :role
  end
end