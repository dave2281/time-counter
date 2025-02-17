class CreateDailyLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_logs do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :deed, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
