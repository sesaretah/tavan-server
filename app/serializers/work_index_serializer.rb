class WorkIndexSerializer < ActiveModel::Serializer
  cache key: "work_index_serializer", expires_in: 3.hours
  include Rails.application.routes.url_helpers
  attributes :id, :title, :details, :start_date, :deadline_date, :created_at, 
             :status, :start_date_j, :deadline_date_j, :start_time, :deadline_time,
             :task, :report_alert, :comment_alert,
            :deadline_alert, :priority, :archived

  def task
    object.task
  end



  def comment_alert
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      return Comment.comments_since(user, object)
    end
  end

  def deadline_alert
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      return Work.deadline_since(user, object)
    end
  end

  def report_alert
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      return Report.reports_since(user, object)
    end
  end


  def start_date
    object.start.in_time_zone("Tehran") if object.start
  end

  def start_time
    object.start.in_time_zone("Tehran").strftime("%H:%M") if object.start
  end

  def deadline_time
    object.deadline.in_time_zone("Tehran").strftime("%H:%M") if object.deadline
  end

  def start_date_j
    start = JalaliDate.to_jalali(object.start.in_time_zone("Tehran"))
    "#{start.year}/#{start.month}/#{start.day} " + object.start.in_time_zone("Tehran").strftime("%H:%M") if object.start
  end

  def deadline_date_j
    deadline = JalaliDate.to_jalali(object.deadline.in_time_zone("Tehran"))
    "#{deadline.year}/#{deadline.month}/#{deadline.day} " + object.deadline.in_time_zone("Tehran").strftime("%H:%M") if object.deadline
  end

  def deadline_date
    object.deadline.in_time_zone("Tehran") if object.deadline
  end


  def status
    object.status if object.status
  end
end
