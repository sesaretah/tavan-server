class TimeSheet < ApplicationRecord
    belongs_to :user
    has_many :involvements, :as => :involveable, :dependent => :destroy

    def title
      if self.sheet_date
        sheet_date = JalaliDate.to_jalali(self.sheet_date.in_time_zone("Tehran"))
        return "#{sheet_date.year}/#{sheet_date.month}/#{sheet_date.day}" 
      end
    end

    def comments 
      Comment.where(commentable_type: 'TimeSheet', commentable_id: self.id)
  end

    def self.search_association(q)
        works = Work.search q, star: true
        tasks = Task.search q, star: true
        todos = Todo.search q, star: true
        arr = []
        for work in works 
          arr << {title: I18n.t(:work) + ': ' + work.title, id: work.id, a_type: 'works'}
        end
        for task in tasks 
          arr << {title: I18n.t(:task) + ': ' + task.title, id: task.id, a_type: 'tasks'}
        end
        for todo in todos 
          arr << {title: I18n.t(:todo) + ': ' + todo.title, id: todo.work.id, a_type: 'works'}
        end
        return arr
    end

    def append_date(params)
      self.sheet_date = params['sheet_date'].to_datetime.in_time_zone("Tehran")
      self.save
    end

    def profile
      self.user.profile if self.user
    end

    def add_involvements(involvements, user)
      if !involvements.blank?
          for involvement in involvements
              add_involvement(involvement['id'], user)
          end
      end
    end

  def self.related(user, page)
    involvement_ids = Involvement.where('user_id = ? AND role = ? AND involveable_type = ?', user.id, 'Observer', 'TimeSheet').pluck(:id).uniq
    return self.where('id IN (?)', involvement_ids).order('sheet_date DESC').paginate(page: page, per_page: 20)
  end

  def access(role)
    case role
    when 'Creator'
        return ['edit','view']
    when 'Observer'
        ['view', 'edit']
    when 'Recipient'
        ['view', 'edit']
    when nil
        []
    end
  end
end
