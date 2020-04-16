class AddCustomTextToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :custom_text, :string
  end
end
