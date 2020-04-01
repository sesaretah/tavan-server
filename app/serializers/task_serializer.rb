class TaskSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :details, :start_date, :deadline_date, :created_at, :coworkers, :works, :discussions

  def start_date
    object.start if object.start
  end

  def deadline_date
    object.deadline if object.deadline
  end

  def coworkers
    return []
  end

  def works
    return []
  end

  def discussions
    return []
  end
end
