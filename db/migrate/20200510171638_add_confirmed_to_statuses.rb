class AddConfirmedToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :statuses, :confirmed, :boolean
  end
end
