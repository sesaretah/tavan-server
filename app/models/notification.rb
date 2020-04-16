class Notification < ApplicationRecord
    belongs_to :notifiable, :polymorphic => true
    #belongs_to :user
    after_create :notify_by_mail

    def self.seen_list(notifications)
        for notification in notifications
            notification.seen = true
            notification.save
        end
        return true
    end

    def notify_by_mail

        for target_user_id in self.target_user_ids
            NotificationsMailer.notify_email(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text).deliver_later
        end
    end

    def user
        User.find_by_id(self.source_user_id) if self.source_user_id
    end
end
