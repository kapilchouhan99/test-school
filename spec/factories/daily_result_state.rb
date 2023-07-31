# spec/factories/users.rb
FactoryBot.define do
  factory :daily_result_stat do
    subject {"science"}
    daily_low { Faker::Number.between(from: 1, to: 50) }
    daily_high {Faker::Number.between(from: 100, to: 200)}
    date { Date.today }
  end
end