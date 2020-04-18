class Todo < ApplicationRecord
    belongs_to :work
    belongs_to :user
end
