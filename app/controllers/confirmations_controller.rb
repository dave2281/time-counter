class ConfirmationsController < ApplicationController
  def show
    user = User.find_by(confirmation_token: params[:token])

    if user&.confirmed?
      redirect_to root_path, alert: "Уже подтверждено."
    elsif user
      user.confirm!
      redirect_to sign_in_path, notice: "Email подтверждён. Теперь вы можете войти."
    else
      redirect_to root_path, alert: "Недействительная ссылка подтверждения."
    end
  end
end
