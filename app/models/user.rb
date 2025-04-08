class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :deeds, dependent: :destroy
  has_many :daily_logs, dependent: :destroy

  validates_presence_of :email_address

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
