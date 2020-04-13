class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :commentable, :polymorphic => true
    after_create :notify_by_mail

    def owner
        commentable.user if commentable.user
    end

    def profile
        self.user.profile if self.user && self.user.profile
    end

    def notify_by_mail
        Notification.create(notifiable_id: self.commentable_id, notifiable_type: self.commentable_type, notification_type: 'Comment', source_user_id: self.user_id, target_user_ids: [self.owner.id] , seen: false)
    end

    def self.comments_since(user, obj)
        flag = false
        last_visit = Visit.where(visitable_type: obj.class.name, user_id: user.id, visitable_id: obj.id).order('created_at DESC').first
        last_comment = self.where(commentable_type: 'Task', commentable_id: obj.id).order('updated_at DESC').first if  obj.class.name == 'Task'
        last_comment = self.where(commentable_type: 'Work', commentable_id: obj.id).order('updated_at DESC').first if  obj.class.name == 'Work'
        if !last_visit.blank? && !last_comment.blank?
           if last_visit.created_at < last_comment.updated_at
             flag = true
           end
        end
        if last_visit.blank? && !last_comment.blank?
            flag = true
        end
        return flag
    end
end
