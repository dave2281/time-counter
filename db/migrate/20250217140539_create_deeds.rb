class CreateDeeds < ActiveRecord::Migration[8.0]
  def change
    create_table :deeds do |t|
      t.string :total_time
      t.string :title, null: false
      t.string :description
      t.string :color
      t.boolean :finished, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
