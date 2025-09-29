class AddTimerIsActiveToDailyLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :daily_logs, :timer_is_active, :boolean, default: false
  end
end
