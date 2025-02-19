class DailyLogsController < ApplicationController
  before_action :set_dailylog, only: %i[ show edit update destroy ]

 def toggle_timer
  cache_key = "daily_log_#{Current.user.id}_#{params[:deed_id]}"
  start_time = Rails.cache.read(cache_key)

  if start_time.nil?
    # Таймер запускается
    Rails.cache.write(cache_key, Time.current)
    render json: { running: true }
  else
    # Таймер останавливается
    daily_log = DailyLog.create!(
      user_id: Current.user.id,
      deed_id: params[:deed_id],
      start_time: start_time,
      end_time: Time.current
    )

    # Удаляем временные данные из кэша
    Rails.cache.delete(cache_key)

    render json: { running: false }
  end
end


  def timer_status
    cache_key = "daily_log_#{Current.user.id}_#{params[:deed_id]}"
    start_time = Rails.cache.read(cache_key)
  
    if start_time.nil?
      render json: { running: false }
    else
      render json: { running: true }
    end
  end  

  # GET /dailylogs or /dailylogs.json
  def index
    @dailylogs = Dailylog.all
  end

  # GET /dailylogs/1 or /dailylogs/1.json
  def show
  end

  # GET /dailylogs/new
  def new
    @dailylog = Dailylog.new
  end

  # GET /dailylogs/1/edit
  def edit
  end

  # POST /dailylogs or /dailylogs.json
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

  # PATCH/PUT /dailylogs/1 or /dailylogs/1.json
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

  # DELETE /dailylogs/1 or /dailylogs/1.json
  def destroy
    @dailylog.destroy!

    respond_to do |format|
      format.html { redirect_to dailylogs_path, status: :see_other, notice: "Dailylog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dailylog
      @dailylog = Dailylog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def dailylog_params
      params.require(:dailylog).permit(:user_id, :deed_id, :start_time, :end_time)
    end
end
