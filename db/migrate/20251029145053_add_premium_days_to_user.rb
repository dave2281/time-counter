class AddPremiumDaysToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :premium_start, :datetime, default: nil
    add_column :users, :premium_until, :datetime, default: nil
  end
end
