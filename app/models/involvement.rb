class Involvement < ApplicationRecord
    belongs_to :user
    belongs_to :involveable, :polymorphic => true

    after_save :invalidate_caches
    before_destroy :invalidate_caches

    def invalidate_caches
        Rails.cache.delete("/user_works/#{self.user_id}")
        Rails.cache.delete("/newest_works/#{self.user_id}")
        Rails.cache.delete_matched("/order_by_deadline_for_user/#{self.user_id}/*")
        Rails.cache.delete_matched("/user_related_notifications/#{self.user_id}/*")
    end 


    def change_role(role)
        self.role = role
        self.save
    end

    def reject!
        self.status = 'Reject'
        self.save
    end

    def rejected?
        self.status == 'Reject' ? true : false 
    end

    def accept!
        self.status = 'Accept'
        self.save
    end

    def accepted?
        self.status == 'Accept' ? true : false 
    end

    def waiting!
        self.status = 'Waiting'
        self.save
    end

    def waiting?
        self.status == 'Waiting' ? true : false 
    end
end
