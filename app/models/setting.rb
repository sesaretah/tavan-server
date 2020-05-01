class Setting < ApplicationRecord
    belongs_to :user

    def add_notification_setting(item)
        self.notification_setting = {} if self.notification_setting.blank?
        self.notification_setting[item] = true
    end

    def remove_notification_setting(item)
        self.notification_setting = {} if self.notification_setting.blank?
        self.notification_setting[item] = false
    end
end
