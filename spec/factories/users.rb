FactoryBot.define do
  factory :user do
    nickname              { Faker::Internet.username(specifier: 5..10) }
    email                 { Faker::Internet.free_email }
    password              { Faker::Alphanumeric.alphanumeric(number: 7, min_alpha: 1, min_numeric: 1) }
    password_confirmation { password }
  end
end
