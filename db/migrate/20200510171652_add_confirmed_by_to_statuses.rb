class AddConfirmedByToStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :statuses, :confirmed_by, :integer
  end
end
