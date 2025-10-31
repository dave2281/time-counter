class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :about_project, :contacts, :index ]

  def index
  end

  def main
    @deeds = Current.user.deeds

    case params[:filter]
    when "new"
      @deeds = @deeds.where(finished: false, total_time: nil)
    when "done"
      @deeds = @deeds.where(finished: true)
    when "active"
      @deeds = @deeds.where(finished: false).where.not(total_time: nil)
    when "running"
      @deeds = Deed.with_running_timers(Current.user.id)
    else
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
