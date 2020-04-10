class Task < ApplicationRecord
    belongs_to :user

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
end
