class TimerService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def active_timers_count
    user.daily_logs.where(timer_is_active: true).count
  end

  def can_start_timer?
    active_timers_count < max_active_timers
  end

  def max_active_timers
    premium_service.max_active_timers
  end

  def active_timers
    user.daily_logs.where(timer_is_active: true)
  end

  def stop_all_timers
    active_timers.update_all(timer_is_active: false, end_time: Time.current)
  end

  private

  def premium_service
    @premium_service ||= PremiumService.new(user)
  end
end
