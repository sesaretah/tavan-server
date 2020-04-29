class Task < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:task)
    belongs_to :user
    belongs_to :status, optional: true
    has_many :works, :dependent => :destroy
    has_many :reports, :dependent => :destroy
    has_many :involvements, :as => :involveable, :dependent => :destroy
    after_create :add_admin
    after_save :archive_works

    def archive_works
        if self.archived
            for work in self.works
                work.archived = true
                work.save
            end
        end
    end
    def access(role)
        case role
        when 'Creator'
            return ['edit','works','reports', 'comments', 'statuses', 'view', 'involvements']
        when 'Admin'
            return ['works','reports', 'comments', 'view', 'involvements']
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

    def comments 
        Comment.where(commentable_type: 'Task', commentable_id: self.id)
    end


    def self.user_tasks(user)
        Task.joins(:involvements).where("involvements.involveable_type = ? AND involvements.user_id = ?", 'Task', user.id)
    end

    def self.order_by_title_for_user(user)
        tasks =  user_tasks(user)
        tasks.sort_by{ |obj| obj.title }
    end

    def self.order_by_deadline_for_user(user)
        tasks =  user_tasks(user)
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
