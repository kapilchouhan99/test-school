namespace :result_stats do
	desc 'Daily result stats'
	
	task daily_result_stats: :environment do
		results = Result.where('timestamp >= ?', Date.today).order(:marks)
    puts "Calculating Daily stats for #{Date.today}"
		calculate_daily_states(results)
	end

	task monthly_result_stats: :environment do	
    puts "Today is not monday_of_third_wednesday " unless Date.today == monday_of_third_wednesday?
    calculate_monthly_averages if Date.today == monday_of_third_wednesday?
	end

	def calculate_daily_states(results)
  		daily_stats = {
        date: Date.today,
        subject: results.first&.subject,
        daily_low: results.minimum(:marks),
        daily_high: results.maximum(:marks),
        result_count: results.count
      }
      DailyResultStat.create(daily_stats)
	end

	def calculate_monthly_averages
    # get the daily_result_stats data for at least 5 days before today
    return "There is no DailyResultStat" if DailyResultStat.count == 0

    records_count = 0
    days_to_go_back = 5
    daily_stats = []
    while records_count < 200
      start_date = Date.today - days_to_go_back
      daily_stats = DailyResultStat.where(date: start_date..Date.today)
    	records_count = daily_stats.sum { |day| day[:result_count] }
      days_to_go_back += 1
    end


    
    # calculate the monthly averages
    result_count_used = daily_stats.sum { |day| day[:result_count] }
    monthly_avg_low = daily_stats.sum { |day| day[:daily_low] } / daily_stats.size
    monthly_avg_high = daily_stats.sum { |day| day[:daily_high] } / daily_stats.size
    # create a new MonthlyResultAverage object to store the results
    MonthlyResultAverage.create!(
      date: Date.today,
      subject: 'Science',
      monthly_avg_low: monthly_avg_low.round(2),
      monthly_avg_high: monthly_avg_high.round(2),
      monthly_result_count_used: result_count_used
    )
  end

	def monday_of_third_wednesday?
    today = Date.today
    third_wednesday = (today.beginning_of_month..today.end_of_month).select(&:wednesday?)[2]
    @monday = third_wednesday-2
  end
end
