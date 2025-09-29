class DailyLog < ApplicationRecord
  belongs_to :deed
  belongs_to :user
  before_save :max_active_timers
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

  def max_active_timers
    return unless timer_is_active? # Проверяем только если создаем активный таймер
    
    active_count = user.daily_logs.active_timers.where.not(id: self.id).count
    
    if active_count >= 3
      errors.add(:base, "You have reached the maximum number of active timers (3). Please stop some timers before starting new ones.")
      throw(:abort)
    end
  end

  def update_deed_total_time
    deed.total_time_add
  end
end
