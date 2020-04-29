class AddArchivedToWork < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :archived, :boolean
  end
end
