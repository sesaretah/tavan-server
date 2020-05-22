class AddReplyIdToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :reply_id, :integer
  end
end
