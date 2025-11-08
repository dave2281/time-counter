class DailyLogsController < ApplicationController
  before_action :set_dailylog, only: %i[ edit update destroy ]

  def start_timer
    Rails.logger.info "=== START TIMER REQUEST ==="
    Rails.logger.info "User: #{Current.user.email_address}"
    Rails.logger.info "Deed ID: #{params[:deed_id]}"

    deed = Current.user.deeds.find(params[:deed_id])
    Rails.logger.info "Deed found: #{deed.title}"

    # УПРОЩЕНИЕ: Просто останавливаем любой активный таймер для этого дела
    deed.daily_logs.where(timer_is_active: true).update_all(
      timer_is_active: false,
      end_time: Time.current
    )

    # АВТООЧИСТКА перед проверкой лимита: убираем старые зависшие таймеры (старше 4 часов)
    Current.user.daily_logs.where(timer_is_active: true)
      .where("start_time < ?", 4.hours.ago)
      .update_all(timer_is_active: false, end_time: Time.current)

    # ПРОСТАЯ ПРОВЕРКА ЛИМИТА: используем метод модели
    active_count = Current.user.active_timers_count
    can_start = Current.user.can_start_timer?
    max_timers = Current.user.max_active_timers

    Rails.logger.info "Active timers: #{active_count}, Max: #{max_timers}, Can start: #{can_start}"

    unless can_start
      Rails.logger.warn "Timer limit reached!"
      render json: {
        error: "Maximum #{max_timers} active timers allowed. Please stop some timers first."
      }, status: :unprocessable_entity
      return
    end

    daily_log = deed.daily_logs.build(
      user: Current.user,
      start_time: Time.current,
      timer_is_active: true
    )

    if daily_log.save
      Rails.logger.info "Timer started successfully!"
      deed.total_time_add

      render json: {
        success: true,
        running: true,
        start_time: daily_log.start_time.to_f * 1000,
        elapsed_time: 0
      }
    else
      Rails.logger.error "Failed to save daily_log: #{daily_log.errors.full_messages}"
      render json: {
        error: daily_log.errors.full_messages.first || "Failed to start timer"
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Task not found"
    render json: { error: "Task not found" }, status: :not_found
  rescue => e
    Rails.logger.error "Timer start error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: "Unable to start timer. Please try again." }, status: :internal_server_error
  end

  def stop_timer
    deed = Current.user.deeds.find(params[:deed_id])

    active_timers = deed.daily_logs.where(timer_is_active: true)

    elapsed_time = 0
    active_timers.each do |timer|
      timer.update!(timer_is_active: false, end_time: Time.current)
      if timer.start_time
        elapsed_time = (Time.current - timer.start_time).to_i
      end
    end

    deed.total_time_add

    render json: {
      success: true,
      running: false,
      elapsed_time: elapsed_time,
      total_time: deed.total_time,
      today_time: deed.today
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end



  def timer_status
    deed = Current.user.deeds.find(params[:deed_id])

    # УПРОЩЕНИЕ: Просто ищем активный таймер для этого дела
    active_timer = deed.daily_logs.where(timer_is_active: true).first

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
    render json: { running: false, elapsed_time: 0 }
  rescue => e
    Rails.logger.error "Timer status error: #{e.message}"
    render json: { running: false, elapsed_time: 0 }
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
      @dailylog = Current.user.daily_logs.find(params.expect(:id))
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Daily log not found or access denied."
    end

    def dailylog_params
      params.require(:dailylog).permit(:user_id, :deed_id, :start_time, :end_time)
    end
end
