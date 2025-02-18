class DailyLog < ApplicationRecord
  belongs_to :deed
  belongs_to :user
  after_save :update_deed_total_time

  def start_timer
    update(start_time: Time.current)
  end

  def stop_timer
    update(end_time: Time.current)
  end

  def duration
    if end_time && start_time
      duration_in_seconds = (end_time - start_time).to_i
      hours = duration_in_seconds / 3600
      minutes = (duration_in_seconds % 3600) / 60
      seconds = duration_in_seconds % 60
      "#{hours}h#{minutes}m#{seconds}s"
    else
      "Timer not stopped yet"
    end
  end

  private

  def update_deed_total_time
    deed.total_time_add
  end
end
