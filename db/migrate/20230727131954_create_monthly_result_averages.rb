class CreateMonthlyResultAverages < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_result_averages do |t|
      t.datetime :date
      t.string :subject
      t.float :monthly_avg_low
      t.float :monthly_avg_high
      t.bigint :monthly_result_count_used

      t.timestamps
    end
  end
end
