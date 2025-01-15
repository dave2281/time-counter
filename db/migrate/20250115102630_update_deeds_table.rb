class UpdateDeedsTable < ActiveRecord::Migration[8.0]
  def change
    rename_column :deeds, :time, :total_time

    change_column_default :deeds, :timer_running, false
    change_column_default :deeds, :timer_start_time, nil
  end
end
