class CreateDeeds < ActiveRecord::Migration[8.0]
  def change
    create_table :deeds do |t|
      t.string :title
      t.string :description
      t.string :time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
