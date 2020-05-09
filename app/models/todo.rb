class Todo < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:todo)
    belongs_to :work
    belongs_to :user
    has_many :involvements, :as => :involveable, :dependent => :destroy
    after_create :notify_by_mail

    def add_involvements(involvements, user)
        if !involvements.blank?
            for involvement in involvements
                add_involvement(involvement['id'], user)
            end
        end
    end

    def involvement_exists?(user_id)
        user = User.find(user_id)
        user_involvement(user).blank? ? false : true
    end

    def notify_by_mail
        Notification.create(notifiable_id: self.work.id, notifiable_type: 'Work', notification_type: 'Todo', source_user_id: self.user_id, target_user_ids: self.work.owners , seen: false, custom_text: self.title)
    end

    def check_todo(c, user)
        self.is_done = c if involvement_exists?(user.id)
    end

    def access(role)
        case role
        when 'Creator'
            return ['edit','view']
        when 'Observer'
            ['view']
        when nil
            []
        end
    end

end
