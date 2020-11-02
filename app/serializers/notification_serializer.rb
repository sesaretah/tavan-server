class NotificationSerializer < ActiveModel::Serializer
  cache key: "notification_serializer", expires_in: 3.hours
  attributes :id, :profile, :target_type, :target_id, :notification_text

  
  def profile
    ProfileSerializer.new(object.user.profile).as_json
  end

  def target_type
    object.notifiable_type.tableize 
  end

  def target_id
    object.notifiable_id
  end

  def notification_text 
    object.fcm_text(nil, object.notification_type, object.user.profile.fullname, object.notifiable.title, object.custom_text)
  end
end
