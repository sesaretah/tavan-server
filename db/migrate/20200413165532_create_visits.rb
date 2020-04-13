class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :visitable_id
      t.string :visitable_type
      t.integer :user_id

      t.timestamps
    end
    add_index :visits, :visitable_id
    add_index :visits, :visitable_type
    add_index :visits, :user_id
  end
end
