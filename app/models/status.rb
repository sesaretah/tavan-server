class Status < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:status)
    belongs_to :user
end
