class Deed < ApplicationRecord
  has_many :daily_logs, dependent: :destroy
  belongs_to :user
  before_save :max_deeds_to_create

  validates_presence_of :title

  def total_time_add
    total_time_in_seconds = daily_logs.sum do |log|
      (log.end_time && log.start_time) ? (log.end_time - log.start_time).to_i : 0
    end

    hours = total_time_in_seconds / 3600
    minutes = (total_time_in_seconds % 3600) / 60
    remaining_seconds = total_time_in_seconds % 60

    formatted_total_time = "#{hours}h#{minutes}m#{remaining_seconds}s"

    update(total_time: formatted_total_time)
  end

  def today
    total_time_in_seconds = daily_logs.where(start_time: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day).sum do |log|
      (log.end_time && log.start_time) ? (log.end_time - log.start_time).to_i : 0
    end

    hours = total_time_in_seconds / 3600
    minutes = (total_time_in_seconds % 3600) / 60
    remaining_seconds = total_time_in_seconds % 60

    "#{hours}h#{minutes}m#{remaining_seconds}s"
  end

  def timer_running?
    daily_logs.where(timer_is_active: true).exists?
  end

  def active_timer
    daily_logs.where(timer_is_active: true).first
  end

  def max_deeds_to_create
    if user.deeds.count >= 20
      errors.add(:base, "You have reached the maximum number of tasks (20). Please delete some tasks before creating new ones.")
      throw(:abort)
    end
  end

  def self.with_running_timers(user_id)
    joins(:daily_logs)
      .where(user_id: user_id, daily_logs: { timer_is_active: true })
      .distinct
  end
end
