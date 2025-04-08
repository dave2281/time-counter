FactoryBot.define do
  factory :daily_log do
    association :deed
    association :user
    start_time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    end_time { Faker::Time.forward(hours: 2, from: start_time) }
  end
end