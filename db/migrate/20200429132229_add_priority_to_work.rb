class AddPriorityToWork < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :priority, :string
  end
end
