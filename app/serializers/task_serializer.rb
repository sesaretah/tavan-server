class TaskSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :details, :start_date, :deadline_date, :created_at, :coworkers, :works, :discussions, :participants

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
