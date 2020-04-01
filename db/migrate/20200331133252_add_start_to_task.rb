class AddStartToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :start, :datetime
  end
end
