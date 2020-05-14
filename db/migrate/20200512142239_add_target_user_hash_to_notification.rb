class AddTargetUserHashToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :target_user_hash, :json
  end
end
