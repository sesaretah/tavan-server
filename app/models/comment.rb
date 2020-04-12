class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :commentable, :polymorphic => true
    
    def owner
        commentable.user if commentable.user
    end

    def profile
        self.user.profile if self.user && self.user.profile
    end
end
