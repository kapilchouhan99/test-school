class CreateDailyResultStats < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_result_stats do |t|
      t.date   :date
      t.string :subject
      t.float :daily_low
      t.float :daily_high
      t.bigint :result_count
      t.datetime :timestamp
      t.timestamps
    end
  end
end
