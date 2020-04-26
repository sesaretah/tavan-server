class TimeSheetSerializer < ActiveModel::Serializer
  attributes :id, :morning_report,  :afternoon_report,  :extra_report, 
  :the_associations, :date, :jdate, :profile, :the_involvements, :the_comments
  #belongs_to :user,  serializer: UserSerializer

  def profile
    ProfileSerializer.new(object.profile).as_json if object.profile
  end 

  def the_involvements
    result = []
    if !object.involvements.blank?
      object.involvements.each do |involvement|
        profile = involvement.user.profile
        result << {profile: ProfileSerializer.new(profile).as_json, role: involvement.role}if !profile.blank?
      end
    end
    return result
  end 

  def date
    object.sheet_date.in_time_zone("Tehran") if object.sheet_date
  end

  def jdate
    if object.sheet_date
      sheet_date = JalaliDate.to_jalali(object.sheet_date.in_time_zone("Tehran"))
      "#{sheet_date.year}/#{sheet_date.month}/#{sheet_date.day}" 
    end
  end

  def the_associations
    object.associations.blank? ? [] : object.associations
  end

  def the_comments
    if scope && scope[:user_id]
      ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer, scope: {user_id: scope[:user_id]} ).as_json
    end
  end
end
