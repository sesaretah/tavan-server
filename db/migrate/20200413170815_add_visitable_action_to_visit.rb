class AddVisitableActionToVisit < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :visitable_action, :string
    add_index :visits, :visitable_action
  end
end
