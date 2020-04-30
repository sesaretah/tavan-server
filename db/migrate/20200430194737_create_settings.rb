class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.integer :user_id
      t.boolean :private
      t.json :notification_setting
      t.json :blocked_list

      t.timestamps
    end
  end
end
