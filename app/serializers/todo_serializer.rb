class TodoSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :work_id, :involvements, :check, :work_involvements

  def check
    if object.is_done 
      return true
    else 
      return false
    end
  end

  def involvements
    result = []
    if !object.involvements.blank?
      object.involvements.each do |involvement|
        profile = Profile.where(user_id: involvement['user_id']).first
        result << {profile: ProfileSerializer.new(profile).as_json, role: involvement['role']}if !profile.blank?
      end
    end
    return result
  end 

  def work_involvements
    result = []
    if !object.work.blank? && !object.work.involvements.blank?
      object.work.involvements.each do |involvement|
        profile = Profile.where(user_id: involvement['user_id']).first
        check = object.involvement_exists?(involvement['user_id'])
        result << {profile: ProfileSerializer.new(profile).as_json, check: check}if !profile.blank?
      end
    end
    return result
  end

  
end
