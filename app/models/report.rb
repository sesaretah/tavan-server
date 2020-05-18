class Report < ApplicationRecord
    belongs_to :task, optional: true
    belongs_to :work, optional: true
    belongs_to :user

    after_create :notify_by_mail

    def notify_by_mail
        if !self.work_id.blank?
            Notification.create(notifiable_id: self.work.id, notifiable_type: 'Work', notification_type: 'Report', source_user_id: self.user_id, target_user_ids: self.owners , seen: false, custom_text: self.title)
        else 
            Notification.create(notifiable_id: self.task.id, notifiable_type: 'Task', notification_type: 'Report', source_user_id: self.user_id, target_user_ids: self.owners , seen: false, custom_text: self.title)
        end
    end

    def owners
        if !self.work_id.blank?
            self.work.owners
        else 
            self.task.owners
        end
    end

    def archived
        if !self.work_id.blank?
            self.work.archived
        else 
            self.task.archived
        end
    end

    def profile
        self.user.profile if self.user
    end

    def uploads
        Upload.where(uuid: self.uuid)
    end

    def user_role(user)
        if !self.work_id.blank?
            self.work.user_role(user)
        else 
            self.task.user_role(user)
        end
    end

    def access(role)
        if !self.work_id.blank?
            self.work.access(role)
        else 
            self.task.access(role)
        end
    end

    def comments 
        Comment.where(commentable_type: 'Report', commentable_id: self.id)
    end

    def self.reports_since(user, obj)
        flag = false
        last_visit = Visit.where(visitable_type: obj.class.name, user_id: user.id, visitable_id: obj.id).order('created_at DESC').first
        last_report = self.where(task_id: obj.id).order('updated_at DESC').first if  obj.class.name == 'Task'
        last_report = self.where(work_id: obj.id).order('updated_at DESC').first if  obj.class.name == 'Work'
        if !last_visit.blank? && !last_report.blank?
           if last_visit.created_at < last_report.updated_at
             flag = true
           end
        end
        if last_visit.blank? && !last_report.blank?
            flag = true
        end
        return flag
    end
end
