class WorkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :details, :start_date, :deadline_date, :created_at, 
             :the_participants, :status, 
             :start_date_j, :deadline_date_j, :start_time, :deadline_time,
             :task, :reports, :the_comments, :report_alert, :comment_alert,
            :deadline_alert, :user_access, :the_todos

  def task
    object.task
  end

  def the_todos
    ActiveModel::SerializableResource.new(object.todos.order('created_at DESC'),  each_serializer: TodoSerializer ).as_json
  end

  def the_participants
    result = []
    if !object.participants.blank?
      object.participants.each do |participant|
        p participant['user_id']
        profile = Profile.where(user_id: participant['user_id']).first
        result << {profile: ProfileSerializer.new(profile).as_json, role: participant['role']}if !profile.blank?
      end
    end
    return result
  end 

  def user_access
    access = [1]
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      role = object.user_role(user)
      access = object.access(role)
    end
    return access
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

  def the_comments
    ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer ).as_json
  end

  def reports
    ActiveModel::SerializableResource.new(object.reports,  each_serializer: ReportSerializer ).as_json
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
