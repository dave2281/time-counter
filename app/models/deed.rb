class Deed < ApplicationRecord
  has_many :daily_logs, dependent: :destroy
  belongs_to :user

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
    cache_key = "daily_log_#{user_id}_#{id}"
    Rails.cache.read(cache_key).present?
  end

  def self.with_running_timers(user_id)
    where(user_id: user_id).select do |deed|
      cache_key = "daily_log_#{user_id}_#{deed.id}"
      Rails.cache.read(cache_key).present?
    end
  end
end
