class UserMailer < ApplicationMailer
  def confirmation_email
    @user = params[:user]
    @url = confirm_url(token: @user.confirmation_token)

    # В тестовом режиме отправляем все на dava.bigboy@gmail.com
    # В продакшене - на email пользователя
    recipient_email = Rails.env.production? ? @user.email_address : "dava.bigboy@gmail.com"

    Rails.logger.info "=== SENDING CONFIRMATION EMAIL ==="
    Rails.logger.info "Original user email: #{@user.email_address}"
    Rails.logger.info "Sending to: #{recipient_email}"
    Rails.logger.info "Environment: #{Rails.env}"
    Rails.logger.info "Confirmation URL: #{@url}"
    Rails.logger.info "Token: #{@user.confirmation_token}"
    Rails.logger.info "Mailgun configured: #{Rails.application.credentials.mailgun.present?}"

    mail(to: recipient_email, subject: "Please confirm your account")
  end
end
