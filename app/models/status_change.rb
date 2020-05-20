class StatusChange < ApplicationRecord
    belongs_to :user
    belongs_to :status
    belongs_to :statusable, :polymorphic => true
    def self.user_changes(user_tasks, user_works)
       
        user_task_ids = user_tasks.pluck(:id)
        user_work_ids = user_works.pluck(:id)
        return self.where("(statusable_type = 'Task' AND statusable_id IN (?)) OR  (statusable_type = 'Work' AND statusable_id IN (?))", user_task_ids, user_work_ids ).limit(10)
    end

    def prev_status
        StatusChange.where(statusable_type: self.statusable_type, statusable_id: self.statusable_id).second_to_last
    end
end
