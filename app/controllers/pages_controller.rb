class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :about_project, :contacts, :index ]

  def index
    if authenticated?
      redirect_to pages_main_path
    else
      redirect_to about_project_path
    end
  end

  def main
    @deeds = Current.user.deeds

    if params[:show_finished] == "true"
      @deeds = @deeds.where(finished: true)
    elsif params[:show_finished] == "false"
      @deeds = @deeds.where(finished: false)
    end

    if params[:show_just_created] == "true"
      @deeds = @deeds.where(finished: false, total_time: nil)
    elsif params[:show_just_created] == "false"
      @deeds = @deeds.where(finished: false).where.not(total_time: nil)
    end

    if params[:show_running_timers] == "true"
      running_deeds = Deed.with_running_timers(Current.user.id)
      @deeds = running_deeds
    elsif params[:show_running_timers] == "false"
      all_deeds = @deeds.to_a
      running_deeds = Deed.with_running_timers(Current.user.id)
      @deeds = all_deeds - running_deeds
    end

    if params[:show_all_tasks] == "true"
      @deeds = Current.user.deeds
    end

    @deeds = @deeds.to_a if @deeds.respond_to?(:to_a) && !@deeds.is_a?(Array)

    @pagy, @records = pagy_array(@deeds, items: 2)
  end

  def calendar
    @deeds = Current.user.deeds
  end

  def about_project
  end

  def contacts
  end

  def update_profile
    user = Current.user

    if params[:user][:password].present?
      if user.update(profile_params)
        render json: { success: true, message: "Profile updated successfully!" }
      else
        render json: { success: false, errors: user.errors.full_messages }
      end
    else
      user_params_without_password = profile_params.except(:password, :password_confirmation)
      if user.update(user_params_without_password)
        render json: { success: true, message: "Profile updated successfully!" }
      else
        render json: { success: false, errors: user.errors.full_messages }
      end
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
