class Work < ApplicationRecord
    belongs_to :user
    belongs_to :task
    belongs_to :status, optional: true
    has_many :reports, :dependent => :destroy
    has_many :todos, :dependent => :destroy
    after_create :notify_by_mail
    before_create :set_participants


    def set_participants
        arr = []
        for participant in self.task.participants
            if participant['user_id'] == self.user_id
                participant['role'] = 'Creator'
            end
            arr << participant
        end
        self.participants = arr
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

    def self.user_works(user)# not goog append works to user on add
        arr = []
        for work in Work.all
            arr << work.id if work.participant_exists?(user.id)
        end
        return arr
    end

    def self.newest_works(user)
        self.where("id in (?)", user_works(user)).order('updated_at DESC')
    end


    def access(role)
        case role
        when 'Creator'
            return ['edit','reports', 'comments', 'statuses', 'view', 'participants', 'todos']
        when 'Admin'
            return ['reports', 'comments', 'statuses', 'view', 'participants', 'todos']
        when 'Colleague'
            return ['comments', 'statuses', 'view']
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

    def notify_by_mail
        Notification.create(notifiable_id: self.task.id, notifiable_type: 'Task', notification_type: 'Work', source_user_id: self.user_id, target_user_ids: self.owners , seen: false)
    end

    def owner
        self.task.user if self.task
    end

    def create_notification(type, profile)
        Notification.create(
            notifiable_id: self.id, notifiable_type: 'Work', 
            notification_type: type, source_user_id: self.user_id, 
            target_user_ids: self.owners , seen: false, custom_text: profile.fullname)
    end

    def add_participant(profile_id)
        self.participants = [] if self.participants.blank?
        profile = Profile.find_by_id(profile_id)
        if !profile.blank? && !self.participant_exists?(profile.user_id)
            self.participants << {user_id: profile.user_id, role: 'Observer'}
            self.save
            create_notification('AddParticipant', profile)
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
        for participant in self.task.participants
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
            self.save
            create_notification('RemoveParticipant', profile)
        end
    end

    def append_time(params)
        start_time = params['start_time'].split(':')
        deadline_time = params['deadline_time'].split(':')
        self.start = params['start'].to_datetime.change({ hour: start_time[0].to_i, min: start_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")
        p params['start'].to_datetime
        p params['start'].to_datetime.change({ hour: start_time[0].to_i, min: start_time[1].to_i, sec: 0 })
        p self.start
        self.deadline = params['deadline'].to_datetime.change({ hour: deadline_time[0].to_i, min: deadline_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran") 
        p params['deadline'].to_datetime
        p params['deadline'].to_datetime.change({ hour: deadline_time[0].to_i, min: deadline_time[1].to_i, sec: 0 })
        p self.deadline   
    end

    def comments 
        Comment.where(commentable_type: 'Work', commentable_id: self.id)
    end

    def self.deadline_since(user, obj)
        flag = false
       # last_visit = Visit.where(visitable_type: obj.class.name, user_id: user.id, visitable_id: obj.id).order('created_at DESC').first
        last_work = self.where(task_id: obj.id).order('deadline DESC').first if  obj.class.name == 'Task'
        last_work = obj if  obj.class.name == 'Work'
        if !last_work.blank?
           if  DateTime.current < last_work.deadline && DateTime.current  > last_work.deadline - 2.days
             flag = true
           end
        end
        return flag
    end

end
