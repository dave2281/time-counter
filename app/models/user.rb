class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :deeds, dependent: :destroy
  has_many :daily_logs, dependent: :destroy

  validates_presence_of :email_address
  validates :email_address, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: :password_required?

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_create :generate_confirmation_token

  before_update :assign_role_if_confirmed, if: :confirmed?

  delegate :premium?, :max_deeds, :max_active_timers, :premium_status, :status_badge, to: :premium_service
  delegate :active_timers_count, :can_start_timer?, to: :timer_service

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update!(confirmed_at: Time.current, confirmation_token: nil)
  end

  def assign_role_if_confirmed
    ::Roles::Assigner.new(self).call
  end

  def assign_premium_role(amount_of_days)
    ::Roles::Assigner.new(self).assign_premium_role_command(amount_of_days)
  end

  private

  def premium_service
    @premium_service ||= PremiumService.new(self)
  end

  def timer_service
    @timer_service ||= TimerService.new(self)
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_sent_at = Time.current
  end

  def password_required?
    password.present? || password_confirmation.present?
  end
end
