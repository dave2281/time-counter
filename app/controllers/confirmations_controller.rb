class ConfirmationsController < ApplicationController
  allow_unauthenticated_access
  
  def show
    user = User.find_by(confirmation_token: params[:token])

    if user&.confirmed?
      redirect_to new_session_path, alert: "Account already confirmed. Please sign in."
    elsif user
      user.confirm!
      redirect_to new_session_path, notice: "Email confirmed! You can now sign in."
    else
      redirect_to new_session_path, alert: "Invalid confirmation link."
    end
  end
end
