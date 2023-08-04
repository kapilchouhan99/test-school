# app/services/result_stats_service.rb

class ResultStatsService
  def self.calculate_daily_result_stats
    results = Result.where('timestamp >= ?', Date.today).order(:marks)
    puts "Calculating Daily stats for #{Date.today}"
    calculate_daily_stats(results)
  end

  def self.calculate_monthly_result_stats
    unless today_is_monday_of_third_wednesday?
      puts "Today is not Monday of the third Wednesday." 
      return
    end

    puts "Calculating Monthly averages for #{Date.today}"
    calculate_monthly_averages
  end

  private

  def self.calculate_daily_stats(results)
    daily_stats = {
      date: Date.today,
      subject: results.first&.subject,
      daily_low: results.minimum(:marks),
      daily_high: results.maximum(:marks),
      result_count: results.count
    }
    DailyResultStat.create(daily_stats)
  end

  def self.calculate_monthly_averages
    return "There is no DailyResultStat" if DailyResultStat.count == 0

    records_count = 0 
    days_to_go_back = 5
    daily_stats = []

    while records_count < 200
      start_date = Date.today - days_to_go_back
      daily_stats = DailyResultStat.where(date: start_date..Date.today)
      records_count = daily_stats.sum(:result_count)
      days_to_go_back += 1
    end

    # calculate the monthly averages
    result_count_used = daily_stats.sum(:result_count)
    monthly_avg_low = daily_stats.average(:daily_low).to_f
    monthly_avg_high = daily_stats.average(:daily_high).to_f

    # create a new MonthlyResultAverage object to store the results
    MonthlyResultAverage.create!(
      date: Date.today,
      subject: 'Science',
      monthly_avg_low: monthly_avg_low.round(2),
      monthly_avg_high: monthly_avg_high.round(2),
      monthly_result_count_used: result_count_used
    )
  end

  def self.today_is_monday_of_third_wednesday?
    today = Date.today
    third_wednesday = (today.beginning_of_month..today.end_of_month).select(&:wednesday?)[2]
    today.monday? && today == third_wednesday - 3
  end
end
