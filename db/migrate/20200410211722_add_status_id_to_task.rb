class AddStatusIdToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status_id, :integer
  end
end
