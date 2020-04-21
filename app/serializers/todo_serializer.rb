class TodoSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :work_id, :participants, :participant_tags, :check, :work_participants

  def check
    if object.is_done 
      return true
    else 
      return false
    end
  end

  def participants
    result = []
    if !object.participants.blank?
      object.participants.each do |participant|
        profile = Profile.where(user_id: participant['user_id']).first
        result << {profile: ProfileSerializer.new(profile).as_json, role: participant['role']}if !profile.blank?
      end
    end
    return result
  end 

  def work_participants
    result = []
    if !object.work.blank? && !object.work.participants.blank?
      object.work.participants.each do |participant|
        profile = Profile.where(user_id: participant['user_id']).first
        check = object.participant_exists?(participant['user_id'])
        result << {profile: ProfileSerializer.new(profile).as_json, check: check}if !profile.blank?
      end
    end
    return result
  end

  def participant_tags
    result = []
    if !object.participants.blank?
      object.participants.each do |participant|
        profile = Profile.where(user_id: participant['user_id']).first
        result << {fullname: profile.fullname, id: profile.id}if !profile.blank?
      end
    end
    return result
  end
  
end
