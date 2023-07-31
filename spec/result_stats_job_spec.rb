# spec/lib/tasks/result_stats_spec.rb

require 'rails_helper'
require 'rake'

RSpec.describe 'result_stats rake tasks' do
  before :all do
    Rails.application.load_tasks
  end

  describe 'result_stats:daily_result_stats' do
    context "Create daily result data" do
      before :each do
        5.times {create(:result)}
      end

      it 'creates daily result stats' do
        expect { Rake::Task['result_stats:daily_result_stats'].execute }.to change { DailyResultStat.count }.by(1)
      end

      it 'creates only one record for same timestamp' do
        # expect {Result.all }
        expect { Rake::Task['result_stats:daily_result_stats'].execute }.to change { DailyResultStat.count }.by(1)
      end
    end

    context "Calculate Daily stats" do
      let!(:result_1) { create(:result, marks: 100) }
      let!(:result_2) { create(:result, marks: 150) }
      let!(:result_3) { create(:result, marks: 49) }
      
      it 'creates daily result stats with ' do
        expect { Rake::Task['result_stats:daily_result_stats'].execute }.to change { DailyResultStat.count }.by(1)
      end

      it 'should fetch the correct data and calculate daily stats' do
        # Run the 'result_stats:daily_result_stats' task
        Rake::Task['result_stats:daily_result_stats'].invoke
        expect(DailyResultStat.pluck(:date)).to all(eq(Date.today))
        expect(DailyResultStat.pluck(:daily_low)).to eq([49])
        expect(DailyResultStat.pluck(:daily_high)).to eq([150])
      end
    end
  end

  describe 'result_stats:monthly_result_stats' do
    # Existing test for calculating and storing monthly result statistics
    context 'Create monthly averages' do 
      before :each do
        2000.times {create(:result)}
      end

      it 'should not store any stats if there are no daily stats available' do
        expect {
          Rake::Task['result_stats:monthly_result_stats'].invoke
        }.not_to change { MonthlyResultAverage.count }
      end

      it 'should return a msg if there are no daily stats available' do
        expect {
          Rake::Task['result_stats:monthly_result_stats'].invoke
        }.not_to change { MonthlyResultAverage.count }
      end


      it 'does not include results from previous days' do
        Rake::Task['result_stats:daily_result_stats'].execute
        expect(DailyResultStat.where(subject: "science").count).to eq(1)
      end
    end 

    context 'Create monthly averages' do
        let!(:daily_result_stat_1) { create(:daily_result_stat, date: Date.today - 6, subject: 'Science', daily_low: 70, daily_high: 90, result_count: 205) }
        let!(:daily_result_stat_2) { create(:daily_result_stat, date: Date.today - 5, subject: 'Science', daily_low: 80, daily_high: 100, result_count: 207) }
        let!(:daily_result_stat_3) { create(:daily_result_stat, date: Date.today - 4, subject: 'Science', daily_low: 75, daily_high: 95, result_count: 210) }
        let!(:daily_result_stat_4) { create(:daily_result_stat, date: Date.today - 3, subject: 'Science', daily_low: 85, daily_high: 110, result_count: 203) }
        let!(:daily_result_stat_5) { create(:daily_result_stat, date: Date.today - 2, subject: 'Science', daily_low: 90, daily_high: 120, result_count: 204) }
        let!(:daily_result_stat_6) { create(:daily_result_stat, date: Date.today, subject: 'Science', daily_low: 95, daily_high: 130, result_count: 202) }
        
      before :each do
        create(:monthly_result_average)
        Rake::Task['result_stats:monthly_result_stats'].execute
      end

      it 'calculates monthly result averages' do
        monthly_result_average = MonthlyResultAverage.last
        expect(monthly_result_average.date).to eq(Date.today)
        expect(monthly_result_average.monthly_avg_low).to eq(85)
        expect(monthly_result_average.monthly_avg_high).to eq(111)
      end

      it 'should consider only relevant daily stats for the last 5 days' do
        monthly_result_stat = MonthlyResultAverage.last
        expect(monthly_result_stat.monthly_avg_low).to eq(85) # (80 + 75 + 85 + 90 + 95) / 5
        expect(monthly_result_stat.monthly_avg_high).to eq(111) # (100 + 95 + 110 + 120 + 130) / 5
      end
    end
  end

  describe 'monday_of_third_wednesday?' do
  it 'returns the correct Monday when today is the first day of the month' do
    allow(Date).to receive(:today).and_return(Date.new(2023, 7, 1)) # Saturday

    monday = monday_of_third_wednesday?

    # The third Wednesday of July 2023 is 19th July 2023
    # So, the Monday before that is 17th July 2023
    expect(monday).to eq(Date.new(2023, 7, 17))
  end

  it 'returns the correct Monday when today is the last day of the month' do
    allow(Date).to receive(:today).and_return(Date.new(2023, 7, 31)) # Monday

    monday = monday_of_third_wednesday?

    # The third Wednesday of July 2023 is 19th July 2023
    # So, the Monday before that is 17th July 2023
    expect(monday).to eq(Date.new(2023, 7, 17))
  end

  it 'returns the correct Monday when today is a Wednesday' do
    allow(Date).to receive(:today).and_return(Date.new(2023, 7, 19)) # Wednesday

    monday = monday_of_third_wednesday?
    expect(monday).to eq(Date.new(2023, 7, 17))
  end

  it 'returns the correct Monday when today is a Monday' do
    allow(Date).to receive(:today).and_return(Date.new(2023, 7, 17)) # Monday

    monday = monday_of_third_wednesday?
    expect(monday).to eq(Date.new(2023, 7, 17))
  end
end

end

