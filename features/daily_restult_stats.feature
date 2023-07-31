Feature: Daily Result Stats Calculation

  Scenario: Calculate daily result stats for each subject
    Given there are some results in the database
    When the daily_result_stats task is executed
    Then the daily stats should be calculated for each subject
    And the daily stats should be saved in the DailyResultStat table

  Scenario: Verify correct daily stats calculation
    Given there are some results in the database for a specific date
    When the daily_result_stats task is executed
    Then the daily stats for each subject should be calculated correctly
    And the daily_low, daily_high, and result_count should be accurate

  Scenario: Calculate daily stats with no results
    Given there are no results in the database for a specific date
    When the daily_result_stats task is executed
    Then no daily stats should be created

  Scenario: Calculate daily stats with same marks for a subject
    Given there are some results with the same marks for a subject
    When the daily_result_stats task is executed
    Then the daily_low and daily_high should be the same
    And the result_count should be accurate

  Scenario: Calculate daily stats with no subjects
    Given there are no results in the database
    When the daily_result_stats task is executed
    Then no daily stats should be created
