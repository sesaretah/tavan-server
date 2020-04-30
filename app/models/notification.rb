class Notification < ApplicationRecord
    include ActionView::Helpers::TextHelper
    belongs_to :notifiable, :polymorphic => true
    #belongs_to :user
    after_create :notify_by_mail
    after_create :notify_by_fcm

    def self.seen_list(notifications)
        for notification in notifications
            notification.seen = true
            notification.save
        end
        return true
    end

    def notify_by_mail
        for target_user_id in self.target_user_ids.uniq
            NotificationsMailer.notify_email(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text).deliver_later
        end
    end

    def notify_by_fcm
        for target_user_id in self.target_user_ids.uniq
            target_user = User.find_by_id(target_user_id)
            token = target_user.devices.last.token if target_user && target_user.devices && target_user.devices.last
            fcm_text = fcm_text(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text)
            FcmJob.perform_later(fcm_text[:title], fcm_text[:body], token) if token
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
        end
        return {title: title, body: body}

    end

    def user
        User.find_by_id(self.source_user_id) if self.source_user_id
    end
end
