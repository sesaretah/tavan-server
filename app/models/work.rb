class Work < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:work)
    belongs_to :user
    belongs_to :task
    belongs_to :status, optional: true
    has_many :reports, :dependent => :destroy
    has_many :todos, :dependent => :destroy
    has_many :involvements, :as => :involveable, :dependent => :destroy
    after_create :add_admin
    after_create :notify_by_mail

    def self.user_works(user)
        self.joins(:involvements).where("involvements.involveable_type = ? AND involvements.user_id = ?", 'Work', user.id)
    end

    def self.newest_works(user)
        works =  user_works(user)
        works.sort_by{ |obj| obj.updated_at }.reverse
    end


    def access(role)
        case role
        when 'Creator'
            return ['edit','reports', 'view_reports', 'comments', 'statuses', 'view', 'involvements', 'todos']
        when 'Admin'
            return ['reports', 'view_reports', 'comments', 'statuses', 'view', 'involvements']
        when 'Colleague'
            return ['reports', 'view_reports' ,'comments', 'view']
        when 'Confirmer'
            ['statuses', 'view_reports' ,'view', 'todos']
        when 'Observer'
            ['view']
        when nil
            []
        end
    end


    def notify_by_mail
        Notification.create(notifiable_id: self.task.id, notifiable_type: 'Task', notification_type: 'Work', source_user_id: self.user_id, target_user_ids: self.owners , seen: false, custom_text: self.title)
    end

    def owners
        self.task.involvements.pluck(:user_id).uniq
    end



    def append_time(params)
        start_time = params['start_time'].split(':')
        deadline_time = params['deadline_time'].split(':')
        self.start = params['start'].to_datetime.in_time_zone("Tehran").change({ hour: start_time[0].to_i, min: start_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")
        self.deadline = params['deadline'].to_datetime.in_time_zone("Tehran").change({ hour: deadline_time[0].to_i, min: deadline_time[1].to_i, sec: 0 }).asctime.in_time_zone("Tehran")  
    end

    def archived
        self.task.archived
    end

    def comments 
        Comment.where(commentable_type: 'Work', commentable_id: self.id)
    end

    def self.deadline_since(user, obj)
        flag = false
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
