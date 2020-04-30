class GroupSerializer < ActiveModel::Serializer
  attributes :id, :title, :the_grouping, :tag_grouping
  belongs_to :user

  def the_grouping
    result = []
    if !object.grouping.blank?
      object.grouping.each do |grouping|
        profile = Profile.where(user_id: grouping['user_id']).first
        result << {profile: ProfileSerializer.new(profile).as_json}if !profile.blank?
      end
    end
    return result
  end 

  def tag_grouping
    result = []
    if !object.grouping.blank?
      object.grouping.each do |grouping|
        profile = Profile.where(user_id: grouping['user_id']).first
        result << {fullname: profile.fullname, id: profile.id}if !profile.blank?
      end
    end
    return result
  end 
end
