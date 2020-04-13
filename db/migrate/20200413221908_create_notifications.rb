class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :notifiable_id
      t.string :notifiable_type
      t.integer :source_user_id
      t.json :target_user_ids
      t.string :notification_type
      t.boolean :seen

      t.timestamps
    end
  end
end
