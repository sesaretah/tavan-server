class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :title
      t.integer :work_id
      t.json :participants
      t.boolean :is_done

      t.timestamps
    end
  end
end
