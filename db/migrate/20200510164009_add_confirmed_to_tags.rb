class AddConfirmedToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :confirmed, :boolean
  end
end
