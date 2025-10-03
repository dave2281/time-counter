class CleanupOldTimersJob < ApplicationJob
  queue_as :default

  def perform
    DailyLog.where(timer_is_active: true)
           .where("start_time < ?", 36.hours.ago)
           .update_all(timer_is_active: false, end_time: Time.current)

    Rails.logger.info "Cleaned up old active timers"
  end
end
