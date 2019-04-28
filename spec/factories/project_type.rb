FactoryBot.define do 
  types = ['Авторский надзор', 'Декорирование', 'Полный проект', 'Смешанный проект']

  factory :project_type do
    sequence(:name) { |n| types[n-1] }
  end
  
end