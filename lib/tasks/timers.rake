namespace :timers do
  desc "Clean up old active timers (older than 8 hours)"
  task cleanup: :environment do
    count = DailyLog.where(timer_is_active: true)
                   .where("start_time < ?", 8.hours.ago)
                   .update_all(timer_is_active: false, end_time: Time.current)

    puts "Cleaned up #{count} old active timers"
  end
end
