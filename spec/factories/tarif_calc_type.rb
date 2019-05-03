FactoryBot.define do 
  factory :tarif_calc_type do
    sequence(:name) { |n| "tarif_calc_type_#{n}" }
  end
end