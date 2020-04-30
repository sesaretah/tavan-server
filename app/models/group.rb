class Group < ApplicationRecord
    belongs_to :user

    def add_grouping(grouping)
        self.grouping = [] 
        if !grouping.blank?
            for gr in grouping
                profile = Profile.find_by_id(gr['id'])
                if !profile.blank? && profile.user 
                    self.grouping << {user_id: profile.user.id}
                end
            end
        end
        self.save
    end

end
