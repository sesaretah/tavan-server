class TimeSheet < ApplicationRecord
    belongs_to :user

    def self.search_association(q)
        works = Work.search q, star: true
        tasks = Task.search q, star: true
        todos = Todo.search q, star: true
        arr = []
        for work in works 
          arr << {title: I18n.t(:work) + ': ' + work.title, id: work.id, type: 'Work'}
        end
        for task in tasks 
          arr << {title: I18n.t(:task) + ': ' + task.title, id: task.id, type: 'Task'}
        end
        for todo in todos 
          arr << {title: I18n.t(:todo) + ': ' + todo.title, id: todo.id, type: 'Todo'}
        end
        return arr
    end

    def append_date(params)
      self.sheet_date = params['sheet_date'].to_datetime.in_time_zone("Tehran")
      self.save
    end
end
