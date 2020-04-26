class Involvement < ApplicationRecord
    belongs_to :user
    belongs_to :involveable, :polymorphic => true

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
