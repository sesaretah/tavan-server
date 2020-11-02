class Notification < ApplicationRecord
    include ActionView::Helpers::TextHelper
    belongs_to :notifiable, :polymorphic => true
    #belongs_to :user
    after_create :notify_by_mail
    after_create :notify_by_fcm

    after_save :invalidate_caches
    before_destroy :invalidate_caches

    def invalidate_caches
        Rails.cache.delete_matched("/user_related_notifications/#{self.source_user_id}/*")
        for target_user_id in self.target_user_ids
            Rails.cache.delete_matched("/user_related_notifications/#{target_user_id}/*")
        end
    end 

    def self.seen_list(notifications)
        for notification in notifications
            notification.seen = true
            notification.save
        end
        return true
    end

    def notify_by_mail
        for target_user_id in self.target_user_ids.uniq
            if Setting.check(target_user_id, Notification.notification_type_eql(self.notification_type, self.notifiable.class.name),'email')
                NotificationsMailer.notify_email(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text).deliver_later
            end
        end
    end


    def notify_by_fcm
        for target_user_id in self.target_user_ids.uniq
            if Setting.check(target_user_id, Notification.notification_type_eql(self.notification_type, self.notifiable.class.name),'push')
                target_user = User.find_by_id(target_user_id)
                token = target_user.devices.last.token if target_user && target_user.devices && target_user.devices.last
                fcm_text = fcm_text(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text)
                FcmJob.perform_later(fcm_text[:title], fcm_text[:body], token) if token
            end
        end
    end

    def fcm_text(user_id, notify_type, notifier, notify_text, custom_text, auxiliary_custom_text=nil)
        case notify_type
        when  'Work'
            title = "#{I18n.t(:work_notification)} #{I18n.t(:via)} #{notifier} #{I18n.t(:inside)} #{notify_text}"
            body =  "#{truncate(custom_text)}"
        when  'Task'
            title = "#{I18n.t(:task_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Report'
            title = "#{I18n.t(:report_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Todo'
            title = "#{I18n.t(:todo_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}" 
            body =  "#{truncate(custom_text)}"
        when  'Comment'
            title = "#{I18n.t(:comment_notification)}  #{I18n.t(:via)} #{notifier} #{I18n.t(:onto)} #{notify_text}"
            body =  "#{truncate(custom_text)}"
        when  'AddInvolvement'
            title = "#{custom_text}  #{I18n.t(:is_added_to)} #{notify_text} #{I18n.t(:via)} #{notifier}" 
            body =  "#{truncate(custom_text)}"
        when  'RemoveInvolvement'
            title = "#{custom_text}  #{I18n.t(:removed_from)} #{notify_text} #{I18n.t(:via)} #{notifier}"  
            body =  "#{truncate(custom_text)}"
        when  'ChangeStatus'
            title = "#{I18n.t(:status_changed)} #{notify_text}  #{I18n.t(:via)} #{notifier}"  
            body =  ""
        end
        return {title: title, body: body}
    end


    def self.notification_type_eql(type, model)
        return 'add_comments_to_'+ model.downcase.pluralize+'_' if  type == 'Comment'
        return 'add_reports_to_'+ model.downcase.pluralize+'_' if  type == 'Report'
        return 'add_works_to_'+ model.downcase.pluralize+'_' if  type == 'Work'
        return 'add_todos_to_works' if  type == 'Todo'
        return 'change_status_'+ model.downcase.pluralize+'_' if  type == 'ChangeStatus'
        return 'add_involvement_to_'+ model.downcase.pluralize+'_' if type == 'AddInvolvement'
        return 'remove_involvement_from_'+ model.downcase.pluralize+'_' if type == 'RemoveInvolvement'
    end

    def user
        User.find_by_id(self.source_user_id) if self.source_user_id
    end

    def self.user_related(user, page)
        Rails.cache.fetch("/user_related_notifications/#{user.id}/#{page}", expires_in: 2.hours) do
            self.where("source_user_id != #{user.id} AND target_user_hash ->> '#{user.id}' = 'true'")
        end
    end
end
