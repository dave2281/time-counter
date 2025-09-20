class UserMailer < ApplicationMailer
  def confirmation_email
    @user = params[:user]
    @url = confirmation_url(token: @user.confirmation_token, host: "timetracker.rubydevelopers.org")
    mail(to: @user.email_address, subject: "Please confirm your account")
  end
end
