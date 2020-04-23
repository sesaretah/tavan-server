class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :details, :start_date, :deadline_date, 
             :created_at, :coworkers, :works, :discussions, :participants, 
             :status, :start_date_j, :deadline_date_j, :start_time, 
             :deadline_time, :works, :reports, :the_comments, :the_tags,
             :is_public, :report_alert, :comment_alert, :deadline_alert,
             :user_access, :the_involvements


  
  def works
   if scope && scope[:user_id]
    ActiveModel::SerializableResource.new(object.works.order('deadline DESC'), scope:{user_id: scope[:user_id]} ,each_serializer: WorkSerializer ).as_json
   end
  end

  def user_access
    access = []
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      role = object.user_role(user)
      access = object.access(role)
    end
    return access
  end

  def is_public
    object.public
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

  def reports
    ActiveModel::SerializableResource.new(object.reports,  each_serializer: ReportSerializer ).as_json
  end

  def the_comments
    ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer, scope: {user_id: scope[:user_id]} ).as_json
  end

  def the_tags
    result = []
    for tag in object.taggings
      result << {title: tag.title, id: tag.id}
    end
    return result
   # ActiveModel::SerializableResource.new(object.taggings,  each_serializer: TagSerializer ).as_json
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
    
  end

  def deadline_date_j
    
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
