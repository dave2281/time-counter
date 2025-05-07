class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user
      unless user.confirmed?
        redirect_to new_session_path, alert: "Approve email, before sign in."
        return
      end

      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Неверный email или пароль."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
