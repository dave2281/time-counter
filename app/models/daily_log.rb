class DailyLog < ApplicationRecord
  belongs_to :deed
  belongs_to :user
  after_save :update_deed_total_time
  
  private

  def update_deed_total_time
    deed.total_time_add
  end
end
