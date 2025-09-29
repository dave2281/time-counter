class DailyLog < ApplicationRecord
  belongs_to :deed
  belongs_to :user
  before_save :max_active_timers
  after_save :update_deed_total_time

  private

  def update_deed_total_time
    deed.total_time_add
  end

  def max_active_timers
    if user.daily_logs.where(end_time: nil).count >= 2
      errors.add(:base, "You have reached the maximum number of active timers (5). Please stop some timers before starting new ones.")
      throw(:abort)
    end
  end
end
