class CreateDeeds < ActiveRecord::Migration[8.0]
  def change
    create_table :deeds do |t|
      t.string :name
      t.string :description
      t.string :time

      t.timestamps
    end
  end
end
