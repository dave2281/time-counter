class UsersController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      begin
        UserMailer.with(user: @user).confirmation_email.deliver_now
        redirect_to root_path, notice: "Check your email for confirmation instructions."
      rescue => e
        redirect_to root_path, alert: "Account created but failed to send confirmation email. Please contact support."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password)
  end
end
