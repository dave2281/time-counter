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
end
