# lib/tasks/result_stats.rake

namespace :result_stats do
  desc 'Daily result stats'
  task daily_result_stats: :environment do
    ResultStatsService.calculate_daily_result_stats
  end

  task monthly_result_stats: :environment do
    ResultStatsService.calculate_monthly_result_stats
  end
end
