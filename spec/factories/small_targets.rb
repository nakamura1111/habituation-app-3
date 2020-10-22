FactoryBot.define do
  factory :small_target do
    name { Faker::Lorem.paragraph_by_chars(number: 50) }
    content { Faker::Lorem.paragraph_by_chars(number: 500) }
    happiness_grade { 3 }
    hardness_grade { 1 }
    is_achieved { true }
    association :target
  end
end
