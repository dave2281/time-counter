class DailyLogsController < ApplicationController
  before_action :set_dailylog, only: %i[ show edit update destroy ]

  def toggle_timer
    deed = Current.user.deeds.find(params[:deed_id])
    cache_key = "daily_log_#{Current.user.id}_#{deed.id}"
    start_time = Rails.cache.read(cache_key)

    if start_time.nil?
      Rails.cache.write(cache_key, Time.current)
      render json: { running: true, elapsed_time: 0 }
    else
      end_time = Time.current
      elapsed = end_time - start_time

      DailyLog.create!(
        user_id: Current.user.id,
        deed_id: deed.id,
        start_time: start_time,
        end_time: end_time
      )

      Rails.cache.delete(cache_key)

      render json: { running: false, elapsed_time: elapsed.to_i }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def start_timer
    deed = Current.user.deeds.find(params[:deed_id])
    cache_key = "daily_log_#{Current.user.id}_#{deed.id}"
    start_time = Time.current

    Rails.cache.write(cache_key, start_time)

    render json: {
      running: true,
      start_time: start_time.to_f * 1000,
      elapsed_time: 0
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def stop_timer
    deed = Current.user.deeds.find(params[:deed_id])
    cache_key = "daily_log_#{Current.user.id}_#{deed.id}"
    start_time = Rails.cache.read(cache_key)

    if start_time
      end_time = Time.current
      elapsed = end_time - start_time

      DailyLog.create!(
        user_id: Current.user.id,
        deed_id: deed.id,
        start_time: start_time,
        end_time: end_time
      )

      Rails.cache.delete(cache_key)

      render json: {
        running: false,
        elapsed_time: elapsed.to_i,
        today_formatted: deed.today
      }
    else
      render json: {
        running: false,
        elapsed_time: 0,
        today_formatted: "0h0m0s"
      }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end



  def timer_status
    deed = Current.user.deeds.find(params[:deed_id])
    cache_key = "daily_log_#{Current.user.id}_#{deed.id}"
    start_time = Rails.cache.read(cache_key)

    if start_time.nil?
      render json: { running: false, elapsed_time: 0 }
    else
      elapsed = Time.current - start_time
      render json: {
        running: true,
        elapsed_time: elapsed.to_i,
        start_time: start_time.to_f * 1000
      }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def index
    @dailylogs = Dailylog.all
  end

  def show
  end

  def new
    @dailylog = Dailylog.new
  end

  def edit
  end

  def create
    @dailylog = Dailylog.new(dailylog_params)

    respond_to do |format|
      if @dailylog.save
        format.html { redirect_to @dailylog, notice: "Dailylog was successfully created." }
        format.json { render :show, status: :created, location: @dailylog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dailylog.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @dailylog.update(dailylog_params)
        format.html { redirect_to @dailylog, notice: "Dailylog was successfully updated." }
        format.json { render :show, status: :ok, location: @dailylog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dailylog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dailylog.destroy!

    respond_to do |format|
      format.html { redirect_to dailylogs_path, status: :see_other, notice: "Dailylog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_dailylog
      @dailylog = Dailylog.find(params.expect(:id))
    end

    def dailylog_params
      params.require(:dailylog).permit(:user_id, :deed_id, :start_time, :end_time)
    end
end
