class CleanupOldTimersJob < ApplicationJob
  queue_as :default

  def perform
    # Останавливаем таймеры старше 8 часов (очень консервативно)
    DailyLog.where(timer_is_active: true)
           .where("start_time < ?", 8.hours.ago)
           .update_all(timer_is_active: false, end_time: Time.current)

    Rails.logger.info "Cleaned up old active timers"
  end
end
