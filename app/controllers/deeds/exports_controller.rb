class Deeds::ExportsController < ApplicationController
  before_action :set_deed, only: [ :show ]

  def create
    @deeds = Current.user.deeds.includes(:daily_logs).order(created_at: :desc)

    respond_to do |format|
      format.csv { send_data export_to_csv, filename: "deeds_#{Date.today}.csv", type: "text/csv" }
    end
  end

  def show
    respond_to do |format|
      format.csv { send_data export_deed_to_csv, filename: "deed_#{@deed.id}_#{Date.today}.csv", type: "text/csv" }
    end
  end

  private

  def set_deed
    @deed = Current.user.deeds.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to pages_main_path, alert: "You don't have permission to export this deed."
  end

  def export_to_csv
    require "csv"

    CSV.generate(headers: true) do |csv|
      csv << [ "Title", "Description", "Status", "Created", "Started", "Finished", "Total Time" ]

      @deeds.each do |deed|
        csv << [
          deed.title,
          deed.description,
          deed.finished? ? "Completed" : "In Progress",
          deed.created_at.strftime("%Y-%m-%d %H:%M"),
          deed.daily_logs.first&.created_at&.strftime("%d.%m.%Y %H:%M") || "N/A",
          deed.daily_logs.last&.created_at&.strftime("%d.%m.%Y %H:%M") || "N/A",
          deed.total_time
        ]
      end
    end
  end

  def export_deed_to_csv
    require "csv"

    CSV.generate(headers: true) do |csv|
      csv << [ "Deed Export" ]
      csv << [ "Title", @deed.title ]
      csv << [ "Description", @deed.description || "" ]
      csv << [ "Status", @deed.finished? ? "Completed" : "In Progress" ]
      csv << [ "Created", @deed.created_at.strftime("%Y-%m-%d %H:%M") ]
      csv << [ "Total Time", @deed.total_time ]
      csv << []

      csv << [ "Date", "Start Time", "End Time", "Duration (seconds)", "Duration (formatted)", "Timer Active" ]

      @deed.daily_logs.order(created_at: :asc).each do |log|
        csv << [
          log.start_time&.strftime("%Y-%m-%d") || log.created_at.strftime("%Y-%m-%d"),
          log.start_time&.strftime("%H:%M:%S") || "N/A",
          log.end_time&.strftime("%H:%M:%S") || (log.timer_is_active ? "Running" : "N/A"),
          format_duration(duration_seconds),
          log.timer_is_active ? "Yes" : "No"
        ]
      end

      csv << []
      csv << [ "Total Logs", @deed.daily_logs.count ]
      csv << [ "Total Time", @deed.total_time ]
    end
  end

  def format_duration(seconds)
    return "00:00:00" if seconds.nil? || seconds.zero?

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    format("%02d:%02d:%02d", hours, minutes, secs)
  end
end
