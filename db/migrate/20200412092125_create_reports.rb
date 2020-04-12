class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :title
      t.text :content
      t.json :draft
      t.integer :user_id
      t.integer :task_id
      t.integer :work_id

      t.timestamps
    end
  end
end
