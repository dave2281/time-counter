class Deed < ApplicationRecord
  has_many :daily_logs
  belongs_to :user

  def total_time_add
    total_seconds = daily_logs.sum { |log| (log.end_time - log.start_time).to_i }

    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60

    update(total_time: "#{hours}h#{minutes}m#{seconds}s")
  end

  def today
    daily_logs.where(start_time: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day)
  end
end
