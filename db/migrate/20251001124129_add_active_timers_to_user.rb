class AddActiveTimersToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :active_timers, :integer, default: 0
  end
end
