class Work < ApplicationRecord
    belongs_to :user
    belongs_to :task
    belongs_to :status, optional: true
    has_many :reports
    after_create :notify_by_mail

    def notify_by_mail
        Notification.create(notifiable_id: self.task.id, notifiable_type: 'Task', notification_type: 'Work', source_user_id: self.user_id, target_user_ids: [self.owner.id] , seen: false)
    end

    def owner
        self.task.user if self.task
    end

    def add_participant(profile_id)
        self.participants = [] if self.participants.blank?
        @profile = Profile.find_by_id(profile_id)
        self.participants << @profile.user_id if !@profile.blank? && !self.participants.include?(profile_id)
        self.save
    end

    def remove_participant(profile_id)
        if !self.participants.blank?
            self.participants = self.participants.delete(profile_id)
            self.save
        end
    end

    def append_time(params)
        start_time = params['start_time'].split(':')
        deadline_time = params['deadline_time'].split(':')
        self.start = params['start'].to_datetime.change({ hour: start_time[0].to_i, min: start_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")
        self.deadline = params['deadline'].to_datetime.change({ hour: deadline_time[0].to_i, min: deadline_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")    
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
           if Time.now < last_work.deadline  + 2.days 
             flag = true
           end
        end
        return flag
    end

end
