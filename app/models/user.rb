class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :deeds, dependent: :destroy
  has_many :daily_logs, dependent: :destroy

  validates_presence_of :email_address

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_create :generate_confirmation_token

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update!(confirmed_at: Time.current, confirmation_token: nil)
  end



  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_sent_at = Time.current
  end
end
