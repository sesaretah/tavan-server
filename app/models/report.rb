class Report < ApplicationRecord
    belongs_to :task, optional: true
    belongs_to :work, optional: true
    belongs_to :user

    def profile
        self.user.profile if self.user
    end

    def uploads
        Upload.where(uuid: self.uuid)
    end
end
