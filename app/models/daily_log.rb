class DailyLog < ApplicationRecord
  belongs_to :deed
  belongs_to :user
end
