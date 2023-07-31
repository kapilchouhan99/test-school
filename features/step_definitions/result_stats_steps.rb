# features/step_definitions/result_stats_steps.rb

# features/step_definitions/result_stats_steps.rb

Given("there are some results in the database") do
  # Create some test data using FactoryBot
  Result.create(subject: "Math", marks: 85, timestamp: Date.today)
  Result.create(subject: "Math", marks: 105, timestamp: Date.today)
  Result.create(subject: "Math", marks: 95, timestamp: Date.today)
end

Given("there are some results in the database for a specific date") do
  date = Date.today
  create_test_data_for_date(date)
end

def create_test_data_for_date(date)
  Result.create(subject: "math", marks: 85, timestamp: Date.today)
  Result.create(subject: "math", marks: 105, timestamp: Date.today)
  Result.create(subject: "math", marks: 95, timestamp: Date.today)
end

Given("there are no results in the database for a specific date") do
  clear_database
  
  # Define the specific date for which there should be no results
  specific_date = Date.today
  results_for_specific_date = find_results_by_date(specific_date)
  expect(results_for_specific_date).to be_empty
end


Given("there are some results with the same marks for a subject") do
  # Create some test data with the same marks for a subject using FactoryBot or any other method
  # create_test_data_with_same_marks
end


def clear_database
  Result.delete_all
end


def find_results_by_date(date)
  Result.where(created_at: date)
end

Given("there are no results in the database") do
  clear_database
  expect(no_results?).to be true
end

def no_results?
  Result.count < 1
end

When("the daily_result_stats task is executed") do
  execute_daily_result_stats_task
end

def execute_daily_result_stats_task
  # Call the method to calculate and store the daily stats
  results = Result.where('created_at >= ?', Date.today).order(:marks).group_by { |m| m.subject }
  calculate_daily_stats(results)
end


def calculate_daily_stats(results)
  results.each do |subject, records|
    daily_stats = {
      date: Date.today,
      subject: subject,
      daily_low: records.minimum(:marks),
      daily_high: records.maximum(:marks),
      result_count: records.count
    }

    DailyResultStat.create(daily_stats)
  
  end
end


Then("the daily stats should be saved in the DailyResultStat table") do
  # Implement the logic to check if daily stats are saved in the DailyResultStat table
end

Then("the daily stats for each subject should be calculated correctly") do
  # Implement the logic to check if daily stats are calculated correctly
end

Then("the daily_low, daily_high, and result_count should be accurate") do
  # Implement the logic to check if daily_low, daily_high, and result_count are accurate
end

Then("no daily stats should be created") do
  expect(DailyResultStat.count == 0 )
end


Then("the daily_low and daily_high should be the same") do
  # Implement the logic to check if daily_low and daily_high are the same for a subject
end

Then("the result_count should be accurate") do
  # Implement the logic to check if the result_count is accurate for a subject
end

