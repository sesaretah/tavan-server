class Task < ApplicationRecord
    belongs_to :user
    belongs_to :status, optional: true
    has_many :works
    has_many :reports
    before_save :append_tags

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

    def comments 
        Comment.where(commentable_type: 'Task', commentable_id: self.id)
    end

    def start_time

    end

    def deadline_time

    end

    def append_time(params)
        start_time = params['start_time'].split(':')
        deadline_time = params['deadline_time'].split(':')
        self.start = params['start'].to_datetime.change({ hour: start_time[0].to_i, min: start_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")
        self.deadline = params['deadline'].to_datetime.change({ hour: deadline_time[0].to_i, min: deadline_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")    
    end

    def append_tags
        arr = []
        for tag in self.tags
            arr << tag['id']
        end
        self.tags = arr
    end

    def taggings
        Tag.where('id in (?)', self.tags)
    end

end
