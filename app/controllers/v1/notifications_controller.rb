class V1::NotificationsController < ApplicationController



  def my
    page =  params[:page]
    notifications = Notification.user_related(current_user, page).order('created_at DESC')
    if !notifications.blank?
      render json: { data: ActiveModel::SerializableResource.new(notifications,  each_serializer: NotificationSerializer ).as_json, klass: 'Notification' }, status: :ok   
    end
  end

  def seen
    page =  params[:page]
    notifications = Notification.user_related(current_user, page)
    #Notification.seen_list(notifications)
    render json: { data: ActiveModel::SerializableResource.new(notifications,  each_serializer: NotificationSerializer ).as_json, klass: 'Notification' }, status: :ok   
  end

end
