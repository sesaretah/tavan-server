class Todo < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:todo)
    belongs_to :work
    belongs_to :user
    has_many :involvements, :as => :involveable, :dependent => :destroy

    def add_involvements(involvements)
        if !involvements.blank?
            for involvement in involvements
                add_involvement(involvement['id'])
            end
        end
    end

    def involvement_exists?(user_id)
        user = User.find(user_id)
        user_involvement(user).blank? ? false : true
    end

    def access(role)
        case role
        when 'Creator'
            return ['edit','view']
        when 'Observer'
            ['view']
        when nil
            []
        end
    end

end
