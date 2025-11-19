class AddTagsToDeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :deeds, :tags, :json, default: []
  end
end
