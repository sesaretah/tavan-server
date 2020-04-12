class AddPublicToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :public, :boolean
  end
end
