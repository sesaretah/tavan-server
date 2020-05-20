class CreateStatusChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :status_changes do |t|
      t.integer :statusable_id
      t.string :statusable_type
      t.integer :status_id
      t.integer :user_id

      t.timestamps
    end
    add_index :status_changes, :statusable_type
    add_index :status_changes, :statusable_id
    add_index :status_changes, :status_id
    add_index :status_changes, :user_id
  end
end
