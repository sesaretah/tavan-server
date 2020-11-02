class Task < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:task)
    belongs_to :user
    belongs_to :status, optional: true
    has_many :works, :dependent => :destroy
    has_many :reports, :dependent => :destroy
    has_many :involvements, :as => :involveable, :dependent => :destroy
    after_create :add_admin
    
    after_save :invalidate_caches
    before_destroy :invalidate_caches

    after_save :archive_works

    def archive_works
        if self.archived
            for work in self.works
                work.archived = true
                work.save
            end
        else
            for work in self.works
                work.archived = false
                work.save
            end
        end
    end

    def invalidate_caches
        Rails.cache.delete_matched("/user_tasks/#{self.user_id}/*")
        Rails.cache.delete_matched("/order_by_title_for_user/#{self.user_id}/*")
        Rails.cache.delete_matched("/order_by_deadline_for_user/#{self.user_id}/*")
        Rails.cache.delete_matched("/user_related_notifications/#{user.id}/*")
    end 

    def access(role)
        case role
        when 'Creator'
            return ['edit','works', 'view_reports','reports', 'comments', 'statuses', 'view', 'involvements']
        when 'Admin'
            return ['works', 'view_reports','reports', 'comments', 'view', 'involvements']
        when 'Colleague'
            return ['comments', 'view_reports', 'view']
        when 'Confirmer'
            ['view', 'view_reports','statuses']
        when 'Observer'
            ['view']
        when nil
            []
        end
    end

    def comments 
        Comment.where(commentable_type: 'Task', commentable_id: self.id).order('created_at ASC')
    end


    def self.user_tasks(user, page=1, pp=10)
        Rails.cache.fetch("/user_tasks/#{user.id}/#{pp}/#{page}", expires_in: 2.hours) do
            Task.joins(:involvements).where("involvements.involveable_type = ? AND involvements.user_id = ?", 'Task', user.id).paginate(page: page, per_page: pp)
        end
    end

    def self.order_by_title_for_user(user, page=1, pp=10)
        Rails.cache.fetch("/order_by_title_for_user/#{user.id}/#{pp}/#{page}", expires_in: 2.hours) do
            tasks =  user_tasks(user, page, pp)
            tasks.sort_by{ |obj| obj.title }
        end
    end

    def self.order_by_deadline_for_user(user, page=1, pp=10)
        Rails.cache.fetch("/order_by_deadline_for_user/#{user.id}/#{pp}/#{page}", expires_in: 2.hours) do
            tasks =  user_tasks(user, page, pp)
            tasks.sort_by{ |obj| obj.nearest_deadline }.reverse
        end
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

    def add_group_involvement(group_id, user)
        group = Group.find_by_id(group_id)
        if !group.blank? && !group.grouping.blank?
            for item in group.grouping
                user = User.find_by_id(item['user_id'])
                add_involvement(user.profile.id, user) if user.profile
            end
        end
    end

    def remove_group_involvement(group_id)
        group = Group.find_by_id(group_id)
        if !group.blank? && !group.grouping.blank?
            for item in group.grouping
                user = User.find_by_id(item['user_id'])
                remove_involvement(user.profile.id) if user.profile
            end
        end
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
