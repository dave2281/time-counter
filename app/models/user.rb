class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :deed
  has_many :daily_logs

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
