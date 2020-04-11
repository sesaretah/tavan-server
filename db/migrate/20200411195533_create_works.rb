class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.string :title
      t.string :details
      t.integer :user_id
      t.integer :task_id
      t.datetime :start
      t.datetime :deadline
      t.integer :status_id
      t.json :statuses
      t.json :participants

      t.timestamps
    end
  end
end
