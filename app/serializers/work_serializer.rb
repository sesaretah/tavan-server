class WorkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :details, :start_date, :deadline_date, :created_at, 
             :participants, :status, 
             :start_date_j, :deadline_date_j, :start_time, :deadline_time,
             :task, :reports, :the_comments, :report_alert, :comment_alert, :deadline_alert

  def task
    object.task
  end
  def participants
    result = []
    if !object.participants.blank?
      object.participants.each do |participant|
        @profile = Profile.find_by_id(participant)
        result << ProfileSerializer.new(@profile).as_json if !@profile.blank?
      end
    end
    return result
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
    JalaliDate.new(object.start).to_s + ' ' + object.start.in_time_zone("Tehran").strftime("%H:%M") if object.start
  end

  def deadline_date_j
    JalaliDate.new(object.deadline).to_s + ' ' + object.deadline.in_time_zone("Tehran").strftime("%H:%M") if object.deadline
  end

  def deadline_date
    object.deadline.in_time_zone("Tehran") if object.deadline
  end


  def status
    object.status if object.status
  end
end
