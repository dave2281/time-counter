class DailyLog < ApplicationRecord
  belongs_to :deed
  belongs_to :user
  after_save :update_deed_total_time

  scope :active_timers, -> { where(timer_is_active: true) }
  scope :completed, -> { where(timer_is_active: false) }

  def start_timer!
    update!(timer_is_active: true, start_time: Time.current, end_time: nil)
  end

  def stop_timer!
    update!(timer_is_active: false, end_time: Time.current)
  end

  def active?
    timer_is_active?
  end

  private

  def update_deed_total_time
    deed.total_time_add
  end
end
