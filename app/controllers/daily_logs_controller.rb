class DailyLogsController < ApplicationController
  before_action :set_dailylog, only: %i[ show edit update destroy ]



  def start_timer
    deed = Current.user.deeds.find(params[:deed_id])
    
    # Останавливаем активный таймер если есть
    if deed.timer_running?
      deed.active_timer.stop_timer!
    end
    
    # Создаем новый активный таймер
    daily_log = deed.daily_logs.build(
      user: Current.user,
      start_time: Time.current,
      timer_is_active: true
    )

    if daily_log.save
      render json: {
        running: true,
        start_time: daily_log.start_time.to_f * 1000,
        elapsed_time: 0
      }
    else
      render json: { 
        error: daily_log.errors.full_messages.first || "Failed to start timer"
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def stop_timer
    deed = Current.user.deeds.find(params[:deed_id])
    active_timer = deed.active_timer

    if active_timer
      active_timer.stop_timer!
      elapsed = active_timer.end_time - active_timer.start_time

      render json: {
        running: false,
        elapsed_time: elapsed.to_i,
        today_formatted: deed.today
      }
    else
      render json: {
        running: false,
        elapsed_time: 0,
        today_formatted: deed.today
      }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end



  def timer_status
    deed = Current.user.deeds.find(params[:deed_id])
    active_timer = deed.active_timer

    if active_timer
      elapsed = Time.current - active_timer.start_time
      render json: {
        running: true,
        elapsed_time: elapsed.to_i,
        start_time: active_timer.start_time.to_f * 1000
      }
    else
      render json: { 
        running: false, 
        elapsed_time: 0 
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
