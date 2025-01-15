class AddTimerToDeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :deeds, :timer_running, :boolean
    add_column :deeds, :timer_start_time, :datetime
  end
end
