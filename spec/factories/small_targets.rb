FactoryBot.define do
  factory :small_target do
    name { Faker::Lorem.paragraph_by_chars(number: 50) }
    content { Faker::Lorem.paragraph_by_chars(number: 500) }
    happiness_grade { Happiness.where(id: 1..).sample.id }
    hardness_grade { Hardness.where(id: 1..).sample.id }
    is_achieved { true }
    association :target
  end
end
