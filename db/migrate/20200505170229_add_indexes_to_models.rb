class AddIndexesToModels < ActiveRecord::Migration[5.2]
  def change
    add_index :profiles, :user_id
    
    add_index :roles, :user_id
  
    
    add_index :tasks, :user_id
    add_index :tasks, :status_id
    
    add_index :statuses, :user_id
    
    add_index :works, :user_id
    add_index :works, :task_id
    add_index :works, :status_id
    
    add_index :reports, :user_id
    add_index :reports, :task_id
    add_index :reports, :work_id
    
    add_index :comments, :user_id
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
    
    add_index :tags, :user_id
    
    add_index :notifications, :source_user_id
    add_index :notifications, :notifiable_id
    add_index :notifications, :notifiable_type
    add_index :notifications, :notification_type
    
    add_index :todos, :work_id
    add_index :todos, :user_id

    add_index :time_sheets, :user_id

    add_index :involvements, :user_id
    add_index :involvements, :involveable_id
    add_index :involvements, :involveable_type

    add_index :devices, :user_id

    add_index :groups, :user_id

    add_index :settings, :user_id
  end
end
