FactoryBot.define do
  factory :small_target do
    name { Faker::Lorem.paragraph_by_chars(number: 50) }
    content { Faker::Lorem.paragraph_by_chars(number: 500) }
    happiness_grade { Happiness.all.sample.id }
    hardness_grade { Hardness.all.sample.id }
    is_achieved { true }
    association :target
  end
end
