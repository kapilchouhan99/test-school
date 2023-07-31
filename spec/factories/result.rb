# spec/factories/users.rb
FactoryBot.define do
  factory :result do
    subject {"science"}
    marks { Faker::Number.between(from: 1, to: 200) }
    timestamp { Date.today }
  end
end