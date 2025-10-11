class UsersController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      Rails.logger.info "=== USER CREATED ==="
      Rails.logger.info "Email: #{@user.email_address}"
      Rails.logger.info "Confirmation token: #{@user.confirmation_token}"
      Rails.logger.info "Sending confirmation email..."
      
      begin
        UserMailer.with(user: @user).confirmation_email.deliver_now
        Rails.logger.info "Confirmation email sent successfully!"
        redirect_to root_path, notice: "Check your email for confirmation instructions."
      rescue => e
        Rails.logger.error "Failed to send confirmation email: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
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
