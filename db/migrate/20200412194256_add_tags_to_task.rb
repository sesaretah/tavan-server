class AddTagsToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :tags, :json
  end
end
