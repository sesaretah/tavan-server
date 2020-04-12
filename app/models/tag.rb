class Tag < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:tag)
    belongs_to :user
end
