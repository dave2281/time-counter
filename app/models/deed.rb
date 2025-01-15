class Deed < ApplicationRecord
  belongs_to :user

  def formatted_total_time
    return nil unless total_time.present?

    total_seconds = total_time.to_i
    
    hours = (total_seconds / 3600).to_i
    minutes = ((total_seconds % 3600) / 60).to_i
    seconds = total_seconds % 60

    "#{hours}h#{minutes}m#{seconds}s"
  end

  def start_timer!
    update(timer_running: true, timer_start_time: Time.current) if !timer_running?
  end

  def stop_timer!
    if timer_running?
      elapsed_time = Time.current - timer_start_time
      new_total_time = (total_time.to_f || 0) + elapsed_time
      update(timer_running: false, timer_start_time: nil, total_time: new_total_time)
    end
  end

  def timer_running?
    timer_running
  end

  def elapsed_time
    return 0 unless timer_running?
    Time.current - timer_start_time
  end
end
