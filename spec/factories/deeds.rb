FactoryBot.define do
  factory :deed do
    title { Faker::Company.bs }
    description { Faker::Lorem.paragraph }
    finished { false }
    association :user
  end
end