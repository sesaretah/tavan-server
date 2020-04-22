class Task < ApplicationRecord
    belongs_to :user
    belongs_to :status, optional: true
    has_many :works, :dependent => :destroy
    has_many :reports, :dependent => :destroy
    before_create :add_admin

    def add_admin
        self.participants = []
        self.participants << {user_id: self.user_id, role: 'Creator'}
    end

    def user_role(user) 
        role = nil
        if !self.participants.blank?
            for participant in self.participants
                if participant['user_id'] == user.id
                    role =  participant['role']
                end
            end
        end
        return role
    end


    def access(role)
        case role
        when 'Creator'
            return ['edit','works','reports', 'comments', 'statuses', 'view', 'participants']
        when 'Admin'
            return ['works','reports', 'comments', 'view', 'participants']
        when 'Colleague'
            return ['comments', 'view']
        when 'Confirmer'
            ['view','statuses']
        when 'Observer'
            ['view']
        when nil
            []
        end
    end

    def change_role(profile_id, role)
        profile = Profile.find_by_id(profile_id)
        if !self.participants.blank?
            for participant in self.participants
                if participant['user_id'] == profile.user_id
                    participant['role'] = role if participant['role'] != 'Creator'
                end
            end
            self.save
        end
    end

    def create_notification(type, profile)
        Notification.create(
            notifiable_id: self.id, notifiable_type: 'Task', 
            notification_type: type, source_user_id: self.user_id, 
            target_user_ids: self.owners , seen: false, custom_text: profile.fullname)
    end



    def add_participant(profile_id)
        self.participants = [] if self.participants.blank?
        profile = Profile.find_by_id(profile_id)
        if !profile.blank? && !self.participant_exists?(profile.user_id)
            self.participants << {user_id: profile.user_id, role: 'Observer'}
            if self.save
                for work in self.works
                    work.add_participant(profile.id)
                end
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
        return arr
    end

    def remove_participant(profile_id)
        profile = Profile.find_by_id(profile_id)
        if !self.participants.blank? && !profile.blank? && self.participant_exists?(profile.user_id)
            new_participants = []
            for participant in self.participants
                if participant['user_id'] != profile.user_id
                    new_participants << participant
                end
            end
            self.participants = new_participants
            if self.save
                for work in self.works
                    work.remove_participant(profile.id)
                end
                create_notification('RemoveParticipant', profile)
            end   
        end
    end

    def comments 
        Comment.where(commentable_type: 'Task', commentable_id: self.id)
    end

    def self.user_tasks(user)# not goog append tasks to user on add
        arr = []
        for task in Task.all
            arr << task.id if task.participant_exists?(user.id)
        end
        return arr
    end

    def self.order_by_title_for_user(user)
        tasks = self.where("id in (?)", user_tasks(user))
        tasks.sort_by{ |obj| obj.title }
    end

    def self.order_by_deadline_for_user(user)
        tasks = self.where("id in (?)", user_tasks(user))
        tasks.sort_by{ |obj| obj.nearest_deadline }.reverse
    end

    def nearest_deadline
       nearest = self.works.order('deadline DESC').first
       !nearest.blank? ? nearest.deadline : 1.years.ago
    end

    def append_time(params)
        start_time = params['start_time'].split(':')
        deadline_time = params['deadline_time'].split(':')
        self.start = params['start'].to_datetime.change({ hour: start_time[0].to_i, min: start_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")
        self.deadline = params['deadline'].to_datetime.change({ hour: deadline_time[0].to_i, min: deadline_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")    
    end

    def append_tags
        if !self.tags.blank?
            arr = []
            for tag in self.tags
                arr << tag['id']
            end
            self.tags = arr
        end
        self.save
    end

    def taggings
        Tag.where('id in (?)', self.tags)
    end

end
