class TaskSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :details, :start_date, :deadline_date, 
             :created_at, :coworkers, :works, :discussions, :participants, 
             :status, :start_date_j, :deadline_date_j, :start_time, 
             :deadline_time, :works, :reports, :the_comments, :the_tags

  
  def works
    result = []
    for work in object.works 
      if work.status
        status = {title: work.status.title, color: work.status.color} 
      else 
        status = nil
      end
      result << {id: work.id, title: work.title, details: work.details, status: status}
    end
    return result
  end

  def reports
    ActiveModel::SerializableResource.new(object.reports,  each_serializer: ReportSerializer ).as_json
  end

  def the_comments
    ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer ).as_json
  end

  def the_tags
    ActiveModel::SerializableResource.new(object.taggings,  each_serializer: TagSerializer ).as_json
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


  def coworkers
    return []
  end


  def discussions
    return []
  end

  def status
    object.status if object.status
  end
end
