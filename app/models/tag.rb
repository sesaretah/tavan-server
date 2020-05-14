class Tag < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:tag)
    belongs_to :user

    def self.filter_unconfirmed(tags, user)
        result = []
        for tag in tags
            result << tag if tag.confirmed || tag.user_id == user.id
        end
        return result
    end
end
