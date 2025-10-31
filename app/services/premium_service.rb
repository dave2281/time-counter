class PremiumService
  FREE_MAX_DEEDS = 20
  PREMIUM_MAX_DEEDS = 100
  FREE_MAX_TIMERS = 1
  PREMIUM_MAX_TIMERS = 5

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def premium?
    user.roles == "premium" && !premium_expired?
  end

  def max_deeds
    premium? ? PREMIUM_MAX_DEEDS : FREE_MAX_DEEDS
  end

  def max_active_timers
    premium? ? PREMIUM_MAX_TIMERS : FREE_MAX_TIMERS
  end

  def premium_expired?
    return false unless user.premium_until.present?
    user.premium_until < Time.current
  end

  def days_until_expiration
    return nil unless premium? && user.premium_until.present?
    ((user.premium_until - Time.current) / 1.day).ceil
  end

  def premium_status
    return :free unless user.roles == "premium"
    return :expired if premium_expired?
    :active
  end

  def status_badge
    case premium_status
    when :active
      { text: "⭐ PREMIUM", class: "bg-yellow-500 text-black" }
    when :expired
      { text: "❌ EXPIRED", class: "bg-red-500 text-white" }
    else
      { text: "FREE", class: "bg-gray-600 text-white" }
    end
  end
end
