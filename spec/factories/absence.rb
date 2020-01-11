FactoryBot.define do 
  
  sequence :comment do |n|
     "комментарий такой-то ##{n}"
  end

  factory :absence do
    comment
    association :reason, factory: :reason
    # association :project, factory: :project
    association :target, factory: :absence_target
    association :user, factory: :user
  end
  
end