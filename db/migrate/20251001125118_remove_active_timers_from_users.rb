class RemoveActiveTimersFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :active_timers, :integer
  end
end
