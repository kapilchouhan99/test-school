# spec/factories/users.rb
FactoryBot.define do
  factory :monthly_result_average do
    date {Date.today}
    subject {"science"}
    monthly_avg_low {100}
    monthly_avg_high {178}
    monthly_result_count_used {201}
  end
end

