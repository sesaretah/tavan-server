class Todo < ApplicationRecord
    belongs_to :work
    belongs_to :user

    def add_participants(participants)
        self.participants = []
        if !participants.blank?
            for participant in participants
                add_participant(participant['id'])
            end
        end
    end

    def add_participant(profile_id)
        self.participants = [] if self.participants.blank?
        profile = Profile.find_by_id(profile_id)
        if !profile.blank? && !self.participant_exists?(profile.user_id)
            self.participants << {user_id: profile.user_id, role: 'Observer'}
            if self.save
                create_notification('AddParticipant', profile)
            end
        end
    end

    def participant_exists?(user_id)
        flag = false
        if !self.participants.blank?
            for participant in self.participants
                if participant['user_id'] == user_id
                    flag = true
                end
            end
        end
        return flag
    end

    def owners 
        arr = []
        for participant in self.participants
            arr << participant['user_id']
        end
        for participant in self.work.participants
            if participant['role'] == 'Creator' ||  participant['role'] == 'Admin'
                arr << participant['user_id']
            end
        end
        return arr.uniq
    end

    def create_notification(type, profile)
        Notification.create(
            notifiable_id: self.id, notifiable_type: 'Todo', 
            notification_type: type, source_user_id: self.user_id, 
            target_user_ids: self.owners , seen: false, custom_text: profile.fullname)
    end

end
